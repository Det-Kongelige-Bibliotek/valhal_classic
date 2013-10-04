# -*- encoding : utf-8 -*-
module Datastreams
  #This class is designed to reflect the METS 1.9.1 schema with emphasis upon the structMap element used for defining
  #the sequential order in which files appear
  class PreservationDatastream < ActiveFedora::OmDatastream

    set_terminology do |t|
      t.root(path: 'fields')
      t.preservation_profile(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable], :path=>'preservation_profile', :label=>'Preservation Profile')
      t.preservation_state(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable], :path=>'preservation_state', :label=>'Preservation State')
      t.preservation_details(:type => :string, :index_as=>[:stored_searchable, :displayable], :path=>'preservation_details', :label=>'Preservation Details')
      t.preservation_date(:type => :string, :index_as => [:stored_searchable, :displayable, :sortable], :path => 'preservation_date', :label => 'Preservation Date')
      t.preservation_comment(:type => :string, :index_as => [:stored_searchable, :displayable, :sortable], :path => 'preservation_comment', :label => 'Preservation Comment')
    end

    def self.xml_template
      Nokogiri::XML.parse('<fields/>')
    end
  end
end