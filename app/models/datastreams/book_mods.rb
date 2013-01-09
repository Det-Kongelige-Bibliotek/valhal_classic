# -*- encoding : utf-8 -*-
module Datastreams
  # Needs class description.
  # Check with User/Data-team whether we use ISO639-2b or RFC4646.
  class BookMods < ActiveFedora::NokogiriDatastream
    set_terminology do |t|
      t.root(:path=>'mods', :xmlns=>"http://www.loc.gov/mods/v3")
      t.uuid(:path=>"identifier[@type='uri']", :index_as => [:searchable])
      t.isbn(:path=>"identifier[@type='isbn']", :index_as => [:searchable])
      t.genre(:index_as=>[:searchable])
      t.typeOfResource(:index_as=>[:searchable])
      t.location do
        t.shelfLocator(:index_as=>[:searchable])
      end
      t.titleInfo do
        t.title(:index_as => [:searchable])
        t.subTitle(:index_as => [:searchable])
      end
      t.originInfo do
        t.publisher(:index_as => [:searchable])
        t.place do
          t.placeTerm(:index_as => [:searchable])
        end
        t.dateIssued(:index_as => [:searchable])
      end
      t.language do
        t.languageISO(:path=>"languageTerm[@authority='iso639-2b']", :index_as => [:searchable])
        t.languageText(:path=>"languageTerm[@type='text']", :index_as => [:searchable])
      end
      t.subject(:path=>"subject[@authority='lcsh']") do
        t.topic(:index_as => [:searchable])
      end
      t.physicalDescription do
        t.extent(:index_as => [:searchable])
      end

      t.shelfLocator(:proxy => [:location, :shelfLocator])
      t.title(:proxy => [:titleInfo, :title])
      t.subTitle(:proxy => [:titleInfo, :subTitle])
      t.publisher(:proxy => [:originInfo, :publisher])
      t.originPlace(:proxy => [:originInfo, :place, :placeTerm])
      t.dateIssued(:proxy => [:originInfo, :dateIssued])
      t.languageISO(:proxy => [:language, :languageISO])
      t.languageText(:proxy => [:language, :languageText])
      t.subjectTopic(:proxy => [:subject, :topic])
      t.physicalExtent(:proxy => [:physicalDescription, :extent])
    end

    def self.xml_template
      Nokogiri::XML.parse '<mods:mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org.1999/xlink" version="3.4" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd" xmlns:mods="http://www.loc.gov/mods/v3">
        <mods:genre type="KB Samling"/>
        <mods:identifier type="uri"/>
        <mods:identifier type="isbn"/>
        <mods:location>
          <mods:shelfLocator/>
        </mods:location>
        <mods:recordInfo>
          <mods:recordContentSource/>
          <mods:recordOrigin/>
          <mods:recordCreationDate encoding="w3cdtf"/>
          <mods:recordChangeDate encoding="w3cdtf"/>
          <mods:recordIdentifier/>
          <mods:languageOfCataloging>
            <mods:languageTerm authority="iso639-2b" type="code"/>
          </mods:languageOfCataloging>
        </mods:recordInfo>
        <mods:relatedItem type="otherFormat">
          <mods:identifier displayLabel="image" type="uri"/>
        </mods:relatedItem>
        <mods:titleInfo>
          <mods:title/>
          <mods:subTitle/>
        </mods:titleInfo>
        <mods:originInfo>
          <mods:place>
            <mods:placeTerm type="text"/>
          </mods:place>
          <mods:publisher></mods:publisher>
          <mods:dateIssued keyDate="yes" encoding="w3cdtf"/>
        </mods:originInfo>
        <mods:language>
            <mods:languageTerm authority="iso639-2b"></mods:languageTerm>
            <mods:languageTerm type="text"></mods:languageTerm>
        </mods:language>
        <mods:subject authority="lcsh">
          <mods:topic/>
        </mods:subject>
        <mods:physicalDescription>
          <mods:extent/>
        </mods:physicalDescription>
        <mods:typeOfResource/>
      </mods:mods>'
    end
  end
end
