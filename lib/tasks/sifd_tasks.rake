# -*- encoding : utf-8 -*-
require 'yaml'
require 'net/http'
require 'uri'

namespace :sifd do
  desc "Delete all ActiveFedora::Base objects from solr and fedora"
  task :clean => :environment do
    #ping_solr
    objects = ActiveFedora::Base.all
    objects.each {|af| af.delete }
    puts "#{objects.length} objects deleted from #{Rails.env.titleize} environment"
  end
  desc "Add FITS file characterization datastream to all SIFD BasicFile objects that don't have it"
  task :characterize_all => :environment do
    add_file_characterization_to_all_basic_files
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

  def add_file_characterization_to_all_basic_files
    bfs = BasicFile.all
    bfs.each do |bf|
        if bf.datastreams['fitsMetadata1'].nil?
          puts 'No FITS datastream found, going to add one...'
          #need to create a new temp file using the content from the datastream
          temp_file = File.new("temp_content_file", "r+")

          temp_file.puts bf.content.content.force_encoding("UTF-8")

          f = ActionDispatch::Http::UploadedFile.new(filename: bf.content.label, type: bf.content.profile['dsMIME'], tempfile: temp_file)

          begin
            fitsMetadata = Hydra::FileCharacterization.characterize(f, f.original_filename, :fits)
          rescue Hydra::FileCharacterization::ToolNotFoundError => tnfe
            logger.error tnfe.to_s
            logger.error 'Tool for extracting FITS metadata not found, continuing with normal processing...'
            return
          rescue RuntimeError => re
            logger.error 'Something went wrong with extraction of file metadata using FITS'
            logger.error re.to_s
            logger.error 'Continuing with normal processing...'
            return
          end
          fitsDatastream = ActiveFedora::OmDatastream.from_xml(fitsMetadata)
          fitsDatastream.digital_object = bf.inner_object

          bf.add_datastream(fitsDatastream, {:prefix => 'fitsMetadata'})
          bf.save
          temp_file.close
          FileUtils.remove "temp_content_file"
        else
          puts bf.datastreams['fitsMetadata1']
        end
      end
  end

end