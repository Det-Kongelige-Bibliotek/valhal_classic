# -*- encoding : utf-8 -*-

class Author < ActiveFedora::Base

  has_metadata :name => 'descMetadata', :type => Datastreams::AdlTeiP5Datastream

  delegate :surname, :to =>'descMetadata'
  delegate :forename, :to =>'descMetadata'
  delegate :date_of_birth, :to =>'descMetadata'
  delegate :date_of_death, :to =>'descMetadata'
  delegate :short_biography, :to => 'descMetadata'
  delegate :sample_quotation, :to => 'descMetadata'
  delegate :sample_quotation_source, :to => 'descMetadata'
end
