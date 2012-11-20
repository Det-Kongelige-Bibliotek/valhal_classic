# -*- encoding : utf-8 -*-

class Author < ActiveFedora::Base

  has_metadata :name => 'descMetadata', :type => Datastreams::AdlTeiP5Datastream

  delegate :surname, :to => 'descMetadata', :at => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :persName, :surname]
  delegate :forename, :to => 'descMetadata', :at => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :persName, :forename]
  delegate :date_of_birth, :to => 'descMetadata', :at => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :birth, :date]
  delegate :date_of_death, :to => 'descMetadata', :at => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :death, :date]
  delegate :short_bio, :to => 'descMetadata'
  delegate :sample_quotation, :to => 'descMetadata'
  delegate :sample_quotation_source, :to => 'descMetadata'

end
