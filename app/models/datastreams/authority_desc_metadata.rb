# -*- encoding : utf-8 -*-
module Datastreams

  # Datastream for the descriptive metadata for an AuthorityMetadataUnit.
  class AuthorityDescMetadata < ActiveFedora::OmDatastream

    set_terminology do |t|
      t.root(:path=>'fields')
      t.type()
      t.value()
      t.reference()


      # Person
      t.firstName()
      t.lastName()
      t.title()
      t.dateOfBirth()
      t.dateOfDeath()


      # Place
      t.name()

    end

    def self.xml_template
      Nokogiri::XML.parse '<fields />'
    end
  end
end
