# -*- encoding : utf-8 -*-

class Author < ActiveFedora::Base

  has_metadata :name => 'descMetadata', :type => Datastreams::AdlTeiP5Datastream

  delegate :surname, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :persName, :surname]
  delegate :forename, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :persName, :forename]
  delegate :date_of_birth, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :birth, :date]
  delegate :date_of_death, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :death, :date]
  delegate :short_biography, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :event, :desc]
  delegate :sample_quotation, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :note, :cit, :quote]
  delegate :sample_quotation_source, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :note, :cit, :bibl]
  delegate :image_link, :to => 'descMetadata', :at => [:TEI, :teiHeader, :figure, :graphic, :url]
end
