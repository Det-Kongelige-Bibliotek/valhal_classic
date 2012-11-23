# -*- encoding : utf-8 -*-
module Datastreams
  class MyAdlTeiP5Datastream  < ActiveFedora::NokogiriDatastream
    include OM::XML::Document

    set_terminology do |t|
      t.root(:path=>"TEI", :xmlns=>"http://www.tei-c.org/ns/1.0")

      t.teiHeader {
        t.fileDesc {
          t.sourceDesc {
            t.bibl
          }
        }
        t.profileDesc {
          t.particDesc {
            t.listPerson {
              t.person {
                t.persName {
                  t.surname
                  t.forename
                }
                t.birth {
                  t.date
                }
                t.death{
                  t.date
                }
                t.event {
                  t.type(:path => {:attribute => "type"})
                  t.when(:path => {:attribute => "when"})
                  t.from(:path => {:attribute => "from"})
                  t.to(:path => {:attribute => "to"})
                  t.desc
                }
                t.note {
                  t.cit{
                    t.quote
                    t.bibl
                  }
                }
              }
            }
          }
        }
      }
    end

    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.TEI(:version=>"1.0", "xmlns"=>"http://www.tei-c.org/ns/1.0") {
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
                  xml.listEvent {
                    xml.event(:when => '', :type => '', :from => '', :to => '') {
                      xml.desc
                    }
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
      end
      return builder.doc
    end
  end
end