# -*- encoding : utf-8 -*-
require 'yaml'
require 'net/http'
require 'uri'
require 'logger'
require 'resque/tasks'
require 'resque/scheduler/tasks'

require "#{Rails.root}/app/services/aleph_service"
require "#{Rails.root}/app/helpers/mq_helper"
require "#{Rails.root}/app/services/dissemination_service"
require "#{Rails.root}/app/helpers/preservation_helper"
require "#{Rails.root}/app/helpers/mq_listener_helper"

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

  #Before running this import you must run this search in Aleph to find out the correct number of eDoDs in Aleph
  #http://aleph-00.kb.dk/X?op=find&base=kgl01&library=kgl01&request=wbh=edod
  #TODO this renders the fetch_size argument redundant, should be removed
  desc "Import existing DOD books into valhal"
  task :import_dod, :fetch_size do |t, args|
    args.with_defaults(fetch_size: 10)
    service = AlephService.new
    records = service.find_all_dod_posts(args[:fetch_size])
    logger.info "Aleph records.size = #{records.size}"
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

  desc 'add some letters examples'
  task :letter_examples  => :environment do
    doc = Nokogiri::XML(File.open(Rails.root.join('spec', 'fixtures', 'brev', 'small-tei.xml')))
    work = Work.create(title: 'A test letter book', workType: 'Book')
    LetterVolumeSplitter.parse_letters(doc, work)
  end

  desc 'Read messages of DOD ingest queue, and ingest DOD books into Valhal'
  task :dod_queue_listener => :environment do
    start_time = Time.now
    logger.debug "starting queue listener (rake)"
    unread_messages = read_messages

    logger.debug "Reading #{unread_messages.size} DOD messages"
    #unread_messages.each {|message| handle_digitisation_dod_ebook(JSON.parse(message))}
    counter = 1

    chunks = unread_messages.each_slice(100).to_a
    logger.debug "Splitting into #{chunks.size} chunks of at most 100"

    chunks.each do |chunk|
      chunk.each do |message|
        logger.debug "Processing message number #{counter}"
        handle_digitisation_dod_ebook(JSON.parse(message))
        counter = counter + 1
      end
      logger.debug "Finished chunk"
    end
    logger.debug "Finished all chunks"
    logger.debug "Finished processing DOD queue"
    logger.debug "Task took  #{Time.now - start_time} seconds"
  end



  #Function to read messages from RabbitMQ and store them in an Array
  #@return Array of unread messages
  def read_messages
    begin
      uri = MQ_CONFIG["mq_uri"]
      conn = Bunny.new(uri)
      conn.start
      channel = conn.create_channel

      if MQ_CONFIG["digitisation"]["source"].blank?
        logger.warn "#{Time.now.to_s} WARN: No digitisation source queue defined -> Not listening"
        return
      end

      source = MQ_CONFIG["digitisation"]["source"]
      q = channel.queue(source, :durable => true)

      logger.debug "q.message_count = #{q.message_count}"

      unread_messages = Array.new

      while q.message_count > 0 do
        delivery_info, metadata, payload = q.pop
        unread_messages.push(payload)
      end
      conn.close
      logger.debug "Returning array containing #{unread_messages.length} unread messages"
      unread_messages
    rescue Exception => e
      logger.error " #{e.message}"
      logger.error e.backtrace.join("\n")
    end
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
