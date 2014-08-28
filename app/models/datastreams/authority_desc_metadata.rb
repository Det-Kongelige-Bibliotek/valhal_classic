# -*- encoding : utf-8 -*-
module Datastreams

  # Datastream for the descriptive metadata for an AuthorityMetadataUnit.
  class AuthorityDescMetadata < ActiveFedora::OmDatastream

    set_terminology do |t|
      t.root(:path=>'fields')
      t.type()
      t.value(index_as: :stored_searchable)
      t.reference()
      t.givenName(index_as: :stored_searchable)
      t.surname(index_as: :stored_searchable)
      t.dateOfBirth(index_as: :stored_searchable)
      t.dateOfDeath(index_as: :stored_searchable)
    end

    def self.xml_template
      Nokogiri::XML.parse '<fields />'
    end
  end
end
