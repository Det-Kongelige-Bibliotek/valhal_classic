# -*- encoding : utf-8 -*-
module Datastreams
  class BookMods < ActiveFedora::NokogiriDatastream
    set_terminology do |t|
      t.root(:path=>'mods', :xmlns=>"http://www.loc.gov/mods/v3")
      t.genre(:index_as=>[:searchable])
      t.uuid(:path=>"identifier[@type='uri']")
      t.local_id(:path=>"identifier[@type='local']")
      t.location do
        t.shelfLocator()
      end
      t.titleInfo do
        t.title(:index_as => [:searchable])
      end
      t.shelfLocator(:proxy => [:location, :shelfLocator])
      t.title(:proxy => [:titleInfo, :title])
    end

    def self.xml_template
      Nokogiri::XML.parse '<mods:mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org.1999/xlink" version="3.4" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd" xmlns:mods="http://www.loc.gov/mods/v3">
        <mods:genre type="KB Samling"/>
        <mods:identifier type="uri"/>
        <mods:identifier type="local"/>
        <mods:location>
          <mods:shelfLocator/>
        </mods:location>
        <mods:recordInfo>
          <mods:recordCreationDate encoding="w3cdtf"/>
          <mods:recordChangeDate encoding="w3cdtf"/>
          <mods:recordIdentifier/>
          <mods:languageOfCataloging>
            <mods:languageTerm authority="rfc4646" type="code"/>
          </mods:languageOfCataloging>
        </mods:recordInfo>
        <mods:relatedItem type="otherFormat">
          <mods:identifier displayLabel="image" type="uri"/>
        </mods:relatedItem>
        <mods:titleInfo>
          <mods:title/>
        </mods:titleInfo>
        <mods:typeOfResource/>
      </mods:mods>'
    end
  end
end
