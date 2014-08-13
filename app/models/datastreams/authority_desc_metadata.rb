# -*- encoding : utf-8 -*-
module Datastreams

  # Datastream for the descriptive metadata for an AuthorityMetadataUnit.
  class AuthorityDescMetadata < ActiveFedora::OmDatastream

    set_terminology do |t|
      t.root(:path=>'fields')
      t.type()
      t.value(index_as: :stored_searchable)
      t.reference()
    end

    def self.xml_template
      Nokogiri::XML.parse '<fields />'
    end
  end
end
