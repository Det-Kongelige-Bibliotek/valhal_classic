# -*- encoding : utf-8 -*-
module Datastreams
  class AdlTeiP5Datastream < ActiveFedora::NokogiriDatastream
    set_terminology do |t|
      t.root(:path=>'TEI', :xmlns=>"http://www.tei-c.org/ns/1.0", :schema=>"file:///home/jatr/work/sifd/ADL/spec/fixtures/adl-tei-schema.rng")

      ##t.title(:path=>"teiHeader/oxns:fileDesc/oxns:titleStmt/oxns:title", :index_as=>[:searchable, :facetable])
      #t.surname(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:persName/oxns:surname", :index_as=>[:searchable])
      #t.forename(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:persName/oxns:forename")
      #t.birth(:path=>"string(teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:birth/@when)")
      #t.birth(:path=>"/*[name()='TEI']/*[name()='teiHeader']/*[name()='profileDesc']/*[name()='particDesc']/*[name()='listPerson']/*[name()='person']/*[name()='birth']/@when")
      #t.death(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:death/@when")
      #t.sample_quotation(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:note/oxns:cit/oxns:quote/")

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
    end

    def self.xml_template
      Nokogiri::XML::Builder.new do |xml|
        xml.root do
          xml.teiHeader
        end
      end.doc
    end
  end
end
