# -*- encoding : utf-8 -*-
module Datastreams
  #This class is designed to reflect the METS 1.9.1 schema with emphasis upon the structMap element used for defining
  #the sequential order in which files appear
  class AdlMets < ActiveFedora::NokogiriDatastream
    include OM::XML::Document

    set_terminology do |t|
      t.root(:path => "mets", :xmlns => "http://www.loc.gov/METS/")

      t.metsHdr do
        t.agent do
          t.name
        end
      end
      t.fileSec do
        t.fileGrp do
          t.file
        end
      end
      t.structMap do
        t.div do
          t.div do
            t.fptr
            t.file_id(:path => {:attribute => "FILEID"})
            t.order(:path => {:attribute => "ORDER"})
          end
          t.order(:path => {:attribute => "ORDER"})
        end
        t.type(:path => {:attribute => "TYPE"})
      end

      t.structmap_type(:proxy => [:structMap, :TYPE])
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.mets(:version => "1.0", "xmlns" => "http://www.loc.gov/METS/") do
          xml.structMap(:ID => '', :TYPE => '', :LABEL => '') do
            xml.div(:ORDER => '', :LABEL => '', :DMDID => '', :ADMID => '', :TYPE => '', :ID => '') do
              xml.fptr(:FILEID => '')
            end
          end
        end
      end
      return builder.doc
    end
  end
end