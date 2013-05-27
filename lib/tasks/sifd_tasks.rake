# -*- encoding : utf-8 -*-
require 'yaml'
require 'net/http'
require 'uri'

namespace :sifd do
  desc "Delete all ActiveFedora::Base objects from solr and fedora"
  task :clean => :environment do
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

end