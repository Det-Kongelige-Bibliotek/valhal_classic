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

end