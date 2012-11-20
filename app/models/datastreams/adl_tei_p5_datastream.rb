# -*- encoding : utf-8 -*-
module Datastreams
  class AdlTeiP5Datastream < ActiveFedora::NokogiriDatastream

    TEI_NS = 'http://www.tei-c.org/ns/1.0'

    set_terminology do |t|
      t.TEI {
        t.teiHeader {
          t.fileDesc {
            t.sourceDesc {
              t.bibl(:index_as=>[:searchable])
            }
          }
          t.profileDesc {
            t.particDesc {
              t.listPerson {
                t.person {
                  t.persName {
                    t.surname(:index_as=>[:searchable])
                    t.forename(:index_as=>[:searchable])
                  }
                  t.birth {
                    t.date()
                  }
                  t.death{
                    t.date()
                  }
                  t.event {
                    t.desc(:index_as=>[:searchable])
                  }
                  t.note {
                    t.cit{
                      t.quote(:index_as=>[:searchable])
                      t.bibl(:index_as=>[:searchable])
                    }
                  }
                }
              }
            }
          }
        }
      }
    end

    def self.xml_template
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.TEI(TEI_NS) {
          xml.teiHeader {
            xml.fileDesc {
              xml.titleStmt {
                xml.title
                xml.respStmt {
                  xml.resp
                  xml.name
                }
                xml.author
              }
              xml.publicationStmt {
                xml.publisher
                xml.idno
              }
              xml.notesStmt {
                xml.note
              }
              xml.sourceDesc {
                xml.bibl
              }
            }
            xml.profileDesc {
              xml.particDesc {
                xml.listPerson {
                  xml.person {
                    xml.persName {
                      xml.surname
                      xml.forename
                    }
                    xml.birth {
                      xml.date
                    }
                    xml.death {
                      xml.date
                    }
                    xml.event {
                      xml.desc
                    }
                    xml.note {
                      xml.cit {
                        xml.quote
                        xml.bibl
                      }
                    }
                  }
                }
              }
            }
          }
        }
      end
    end
  end
end
