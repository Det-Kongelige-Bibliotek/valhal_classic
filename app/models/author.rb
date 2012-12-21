# -*- encoding : utf-8 -*-

class Author < ActiveFedora::Base

  has_metadata :name => 'descMetadata', :type => Datastreams::AdlTeiP5
  has_file_datastream :name => "teiFile", :type => Datastreams::AdlTeiP5
  #has_file_datastream :name => 'authorImageFile', :type => ActiveFedora::Datastream

  delegate_to 'descMetadata', [:forename, :surname, :date_of_birth, :date_of_death, :period], :unique => true
  delegate_to 'descMetadata', [:short_biography, :sample_quotation, :sample_quotation_source]
  #delegate_to 'authorImageFile', [:author_image_file]
end
