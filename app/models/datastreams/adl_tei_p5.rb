# -*- encoding : utf-8 -*-
module Datastreams
  # This class provides mappings between an Author objects attributes and a TEI P5 xml document
  class AdlTeiP5 < ActiveFedora::OmDatastream
    include OM::XML::Document

    # TODO Check whether a XML schema is defined for TEI, and if it is, then add it.
    set_terminology do |t|
      t.root(:path => "TEI", :xmlns => "http://www.tei-c.org/ns/1.0")

      t.teiHeader do
        t.fileDesc do
          t.titleStmt do
            t.title()
          end
          t.sourceDesc do
            t.bibl()
          end
        end
        t.profileDesc do
          t.particDesc do
            t.listPerson do
              t.person do
                t.persName do
                  t.surname
                  t.forename
                end
                t.birth do
                  t.date
                end
                t.death do
                  t.date
                end
                t.event do
                  t.type(:path => {:attribute => "type"})
                  t.when(:path => {:attribute => "when"})
                  t.from(:path => {:attribute => "from"})
                  t.to(:path => {:attribute => "to"})
                  t.desc()
                end
                t.note do
                  t.cit do
                    t.quote()
                    t.bibl()
                  end
                end
                t.floruit do
                  t.period(:path => {:attribute => "period"})
                  t.from(:path => {:attribute => "from"})
                  t.to(:path => {:attribute => "to"})
                end
              end
            end
          end
        end
      end

      t.forename(:proxy => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :persName, :forename])
      t.surname(:proxy => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :persName, :surname])
      t.date_of_birth(:proxy => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :birth, :date])
      t.date_of_death(:proxy => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :death, :date])
      t.short_biography(:proxy => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :event, :desc])
      t.sample_quotation(:proxy => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :note, :cit, :quote])
      t.sample_quotation_source(:proxy => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :note, :cit, :bibl])
      t.period(:proxy => [:teiHeader, :profileDesc, :particDesc, :listPerson, :person, :floruit, :period])
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.TEI(:version => "1.0", "xmlns" => "http://www.tei-c.org/ns/1.0") do
          xml.teiHeader do
            xml.fileDesc do
              xml.titleStmt do
                xml.title
                xml.respStmt do
                  xml.resp
                  xml.name
                end
                xml.author
              end
              xml.publicationStmt do
                xml.publisher
                xml.idno
              end
              xml.notesStmt do
                xml.note
              end
              xml.sourceDesc do
                xml.bibl
              end
            end
            xml.profileDesc do
              xml.particDesc do
                xml.listPerson do
                  xml.person do
                    xml.persName do
                      xml.surname
                      xml.forename
                    end
                    xml.birth do
                      xml.date
                    end
                    xml.death do
                      xml.date
                    end
                    xml.event(:when => '', :type => '', :from => '', :to => '') do
                      xml.desc
                    end
                    xml.note do
                      xml.cit do
                        xml.quote
                        xml.bibl
                      end
                    end
                    xml.floruit(:period => '', :from => '', :to => '')
                  end
                end
              end
            end
          end
        end
      end
      return builder.doc
    end
  end
end
