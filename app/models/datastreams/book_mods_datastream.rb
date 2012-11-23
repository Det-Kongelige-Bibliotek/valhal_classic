# -*- encoding : utf-8 -*-
module Datastreams
  class BookModsDatastream < ActiveFedora::NokogiriDatastream
    set_terminology do |t|
      t.root(:path=>'mods', :xmlns=>"http://www.loc.gov/mods/v3")
      t.genre(:index_as=>[:searchable])
      t.uuid(:path=>"identifier[@type='uri']")
      t.local_id(:path=>"identifier[@type='local']")
      t.location() do
        t.shelfLocator()
      end

      t.titleInfo do
        t.title
      end

    end

    def self.xml_template
      Nokogiri::XML.parse '<mods:mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org.1999/xlink" version="3.4" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd" xmlns:mets="http://www.loc.gov/METS/" xmlns:premis="info:lc/xmlns/premis-v2" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mix="http://www.loc.gov/mix/v20">
  <mods:identifier type="uri"/>
  <mods:identifier type="local"/>
  </mods:mods>'
    end
  end
end
