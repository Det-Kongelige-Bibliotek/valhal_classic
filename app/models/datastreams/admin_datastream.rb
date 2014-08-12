# -*- encoding : utf-8 -*-
module Datastreams

  # Datastream for the administrative metadata for a Work and Instance.
  class AdminDatastream < ActiveFedora::OmDatastream
    set_terminology do |t|
      t.root(:path=>'fields')
      t.collection(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                :path=>'admin_collection', :label=>'Administrative Collection')
      t.activity(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                 :path=>'admin_activity', :label=>'Administrative Activity')

      t.embargo(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                 :path=>'embargo', :label=>'Embargo')
      t.embargo_date(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                :path=>'embargo_date', :label=>'Embargo Date')
      t.embargo_condition(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                :path=>'embargo_condition', :label=>'Embargo Condition')
      t.access_condition(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                :path=>'access_condition', :label=>'Access Condition')

      t.copyright(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                         :path=>'copyright', :label=>'Copyright')
      t.material_type(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                         :path=>'material_type', :label=>'Material type')
      t.availability(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],
                         :path=>'availability', :label=>'Availability')
    end
    def self.xml_template
      Nokogiri::XML.parse('<fields/>')
    end
  end
end
