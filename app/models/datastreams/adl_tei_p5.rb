module KB
  module Datastream
    class AdlTeiP5 < ActiveFedora::NokogiriDatastream
      set_terminology do |t|
        t.root(:path=>'TEI', :xmlns=>"http://www.tei-c.org/ns/1.0")
        t.title(:path=>"teiHeader/oxns:fileDesc/oxns:titleStmt/oxns:title", :index_as=>[:searchable, :facetable])
        t.author_surname(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:persName/oxns:surname", :index_as=>[:searchable])
        t.author_forename(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:persName/oxns:forename")
        t.author_date_of_birth(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:birth/", :attributes=>{:when=>""})
        t.author_date_of_death(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:death/", :attributes=>{:when=>""})
        t.author_quotation(:path=>"teiHeader/oxns:profileDesc/oxns:particDesc/oxns:listPerson/oxns:person/oxns:note/oxns:cit/oxns:quote/")
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
                }
              }
            }
          }
        }
        t.bibl(:proxy=>[:teiHeader, :fileDesc, :sourceDesc, :bibl])
      end
    end
  end
end
