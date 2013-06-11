# -*- encoding : utf-8 -*-
module Datastreams
  #This class is designed to reflect the METS 1.9.1 schema with emphasis upon the structMap element used for defining
  #the sequential order in which files appear
  class MetsStructMap < ActiveFedora::OmDatastream
    include OM::XML::Document

    set_terminology do |t|
      t.root(:path => 'mets', :encoding => 'UTF-8')

      t.structMap do
        t.div do
          t.order(:path => {:attribute => 'ORDER'})
          t.fptr do
            t.file_id(:path => {:attribute => 'FILEID'})
          end
        end
      end

      t.div(:proxy => [:structMap, :div])
      t.order(:proxy => [:structMap, :div, :order])
      t.fptr(:proxy => [:structMap, :div, :fptr])
      t.file_id(:proxy => [:structMap, :div, :fptr, :file_id])
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.mets(:version => '1.0', 'xmlns' => 'http://www.loc.gov/METS/') do
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