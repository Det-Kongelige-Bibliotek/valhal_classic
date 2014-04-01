# -*- encoding : utf-8 -*-
require 'yaml'
require 'net/http'
require 'uri'
require 'logger'


require "#{Rails.root}/app/services/aleph_service"
require "#{Rails.root}/app/helpers/mq_helper"
require "#{Rails.root}/app/services/dissemination_service"

namespace :sifd do
  include MqHelper
  include DisseminationService

  desc "Delete all ActiveFedora::Base objects from solr and fedora"
  task :clean => :environment do
    if Rails.env.to_s.eql? 'test'
      WebMock.allow_net_connect!
    end
    objects = ActiveFedora::Base.all
    objects.each {|af| af.delete }
    if Rails.env.to_s.eql? 'test'
      WebMock.disable_net_connect!(allow_localhost: true)
    end
    puts "#{objects.length} objects deleted from #{Rails.env.titleize} environment"
  end
  desc "Add FITS file characterization datastream to all SIFD BasicFile objects that don't have it"
  task :characterize_all => :environment do
    add_file_characterization_to_all_basic_files
  end

  desc "Import existing DOD books into valhal"
  task :import_dod, :fetch_size do |t, args|
    args.with_defaults(fetch_size: 10)
    service = AlephService.new
    records = service.find_all_dod_posts(args[:fetch_size])
    messages = records.collect { |r| service.convert_marc_to_message(r) }
    MQ_CONFIG = YAML.load_file("#{Rails.root}/config/mq_config.yml")[Rails.env]
    queue_name = MqHelper.get_queue_name('digitisation', 'source')
    messages.each {|m| MqHelper.send_on_rabbitmq(m, queue_name)}
    logger.info "sent #{messages.length} messages on #{queue_name}"
  end

  desc "Disseminate all Valhal works to Bifrost"
  task :disseminate => :environment do
    works = Work.all
    puts "Sending #{works.length} objects to dissemination."
    works.each do | work |
      url = Nokogiri::XML(work.descMetadata.to_xml).css('url').last.content
      disseminate(work, {'fileUri' => url}, DisseminationService::DISSEMINATION_TYPE_BIFROST_BOOKS)
    end

  end

  desc 'Utility task to debug import of single item, takes Aleph sysNum as arg'
  task :debug_import, [:sysNum] => :environment do |t, args|
    # exit if we don't get any args
    if args[:sysNum].nil?
      puts 'Expected aleph sysNum as argument - exiting'
      next
    end
    service = AlephService.new
    set = service.find_set("sys=#{args[:sysNum]}")
    xml = service.get_record(set[:set_num], '1')
    puts '============== Aleph XML =================='
    puts xml
    slim = ConversionService.transform_aleph_to_slim_marc(xml, 'somebullshit.pdf')
    puts '============== Slimmed down MARC XML =================='
    puts slim
    mods = ConversionService.transform_marc_to_mods(slim)
    puts '============== MODS =================='
    puts mods
  end

  desc 'Read messages of DOD ingest queue, and ingest DOD books into Valhal'
  task :dod_queue_listener => :environment do
    logger.debug "starting queue listener (rake)"
    begin
      uri = MQ_CONFIG["mq_uri"]
      conn = Bunny.new(uri)
      logger.debug "Before starting Bunny connection..."
      logger.debug "rake task sifd.dod_queue_listener: num_of_threads = #{Thread.current.group.list.size}"
      if Thread.current.group.list.size > 1
        Thread.current.group.list.each do |thread|
          logger.debug thread.inspect
        end
      else
        logger.debug Thread.current.inspect
      end
      conn.start
      logger.debug "After starting Bunny connection..."
      logger.debug "rake task sifd.dod_queue_listener: num_of_threads = #{Thread.current.group.list.size}"
      if Thread.current.group.list.size > 1
        Thread.current.group.list.each do |thread|
          logger.debug thread.inspect
        end
      else
        logger.debug Thread.current.inspect
      end
      ch = conn.create_channel
      subscribe_to_dod_digitisation(ch)
      conn.close
    rescue Exception => e
      logger.error " #{e.message}"
      logger.error e.backtrace.join("\n")
    end
    logger.debug "The End"
  end

  namespace :solr do
    desc "Reload the local jetty solr with config from solr_conf"
    task :reload do
      config = YAML.load(File.read(File.expand_path('../../../config/solr.yml', __FILE__)))
      test_uri = URI.parse config["test"]["url"]
      development_uri = URI.parse config["development"]["url"]

      Rake::Task["jetty:config"].execute

      Net::HTTP.get(test_uri.host, "/solr/admin/cores?action=RELOAD&core=test", test_uri.port)
      Net::HTTP.get(development_uri.host, "/solr/admin/cores?action=RELOAD&core=development", development_uri.port)
    end
  end
  #Because Jetty takes a long time to start Solr and Fedora we need to wait for it before starting the tests
  #Following code attempts to connect to Solr and run a simple query, if the connection refused it catches
  #this error and sleeps for 5 seconds before trying again until successful
  def ping_solr
    begin
      solr = RSolr.connect :url => 'http://localhost:8983/solr'
      response = solr.get 'select', :params => {:q => '*:*'}
      puts 'Solr is up!'
      return
    rescue Errno::ECONNREFUSED
      puts 'Solr not up yet, sleeping for 10 seconds... zzz'
      sleep 10
      ping_solr
    end
  end

  #Function gets all BasicFile objects from the repo and checks to see if they have a fitsMetadata Datastream, if not
  #the function generates one by writing the content from the BasicFile into a temp file and then passing that to the
  #Hydra FileCharacterization gem.  If any problem is encountered running the fits characterisation then the task aborts
  def add_file_characterization_to_all_basic_files
    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO
    logger.datetime_format = "%H:%M:%S"
    bfs = BasicFile.all
    bfs.each do |bf|
        if bf.datastreams['fitsMetadata1'].nil?
          logger.info "No FITS datastream found for #{bf.pid}, going to add one..."
          #need to create a new temp file using the content from the datastream
          temp_file = File.new('temp_content_file', 'w+')
          begin
            temp_file.puts bf.content.content
          rescue StandardError => re
            logger.error 'Got error writing BasicFile contents to file'
            logger.error re.to_s
            if re.to_s.match 'from ASCII-8BIT to UTF-8'
              logger.info 'ASCII file detected'
              temp_file.puts bf.content.content.force_encoding('UTF-8')
            end
          end
          #temp_file.puts bf.content.content.force_encoding('UTF-8')

          f = ActionDispatch::Http::UploadedFile.new(filename: bf.content.label, type: bf.content.profile['dsMIME'], tempfile: temp_file)

          begin
            logger.info 'Generating FITS metadata XML'
            fitsMetadata = Hydra::FileCharacterization.characterize(f, f.original_filename, :fits)
          rescue Hydra::FileCharacterization::ToolNotFoundError => tnfe
            logger.error tnfe.to_s
            abort 'FITS tool not found, terminating, check FITS_HOME environment variable is set and FITS is installed'
          rescue RuntimeError => re
            logger.error 'Something went wrong with extraction of file metadata using FITS'
            logger.error re.to_s
            abort 'FITS tool not found, terminating, check FITS_HOME environment variable is set and FITS is installed'
          end
          fitsDatastream = ActiveFedora::OmDatastream.from_xml(fitsMetadata)
          fitsDatastream.digital_object = bf.inner_object

          bf.add_datastream(fitsDatastream, {:prefix => 'fitsMetadata'})
          bf.save
          logger.info 'FITS metadata datastream added, tidying up resources used'
          temp_file.close
          FileUtils.remove_file 'temp_content_file'
          logger.info "Finished adding FITS metadata for #{bf.pid}"
          logger.info '********************************************'
        end
      end
  end
end