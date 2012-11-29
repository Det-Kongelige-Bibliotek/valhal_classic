# -*- encoding : utf-8 -*-

class Author < ActiveFedora::Base

  has_metadata :name => 'descMetadata', :type => Datastreams::AdlTeiP5

  delegate :surname, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :persName, :surname], :unique=>true
  delegate :forename, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :persName, :forename], :unique=>true
  delegate :date_of_birth, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :birth, :date], :unique=>true
  delegate :date_of_death, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :death, :date], :unique=>true
  delegate :short_biography, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :event, :desc]
  delegate :sample_quotation, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :note, :cit, :quote]
  delegate :sample_quotation_source, :to => 'descMetadata', :at => [:TEI, :teiHeader, :profileDesc, :particDesc, :listPerson, :person, :note, :cit, :bibl]
  delegate :image_link, :to => 'descMetadata', :at => [:TEI, :teiHeader, :figure, :graphic, :url]
end
