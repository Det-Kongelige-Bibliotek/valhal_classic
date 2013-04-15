# -*- encoding : utf-8 -*-
module Datastreams
  # TODO Needs class description.
  # TODO Check with User/Data-team whether we use ISO639-2b or RFC4646.
  # TODO Should mods:genre type be 'KB Samling' as defined by BNH in a document approved at NBO/ADM meetings.
  class WorkMods < ActiveFedora::NokogiriDatastream
    set_terminology do |t|
      t.root(:path=>'mods', :xmlns=>"http://www.loc.gov/mods/v3")
      t.uuid(:path=>"identifier[@type='uri']")
      t.genre()
      t.typeOfResource()
      t.location do
        t.shelfLocator()
      end
      t.titleInfo do
        t.title()
        t.subTitle()
      end
      t.originInfo do
        t.publisher()
        t.place do
          t.placeTerm()
        end
        t.dateIssued()
      end
      t.language do
        t.languageISO(:path=>"languageTerm[@authority='iso639-2b']")
        t.languageText(:path=>"languageTerm[@type='text']")
      end
      t.subject(:path=>"subject[@authority='lcsh']") do
        t.topic()
      end
      t.physicalDescription do
        t.extent()
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
        <mods:genre type="Materialetype"/>
        <mods:identifier type="uri"/>
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
