namespace :sifd do
  desc "Delete all ActiveFedora::Base objects from solr and fedora"
  task :clean => :environment do
    objects = ActiveFedora::Base.all
    objects.each {|af| af.delete }
    puts "#{objects.length} objects deleted from #{Rails.env.titleize} environment"
  end
end