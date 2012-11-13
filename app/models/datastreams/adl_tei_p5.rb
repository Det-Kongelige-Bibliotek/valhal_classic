module KB
  module Datastream
    class AdlTeiP5 < ActiveFedora::NokogiriDatastream
      set_terminology do |t|
        t.root(:path=>'TEI', :xmlns=>"http://www.tei-c.org/ns/1.0")
        t.title(:path=>"teiHeader/oxns:fileDesc/oxns:titleStmt/oxns:title", :index_as=>[:searchable, :facetable])
        t.author(:path=>"teiHeader/oxns:fileDesc/oxns:titleStmt/oxns:author", :index_as=>[:searchable])
        t.maintainer(:path=>"teiHeader/oxns:fileDesc/oxns:titleStmt/oxns:respStmt/oxns:resp", :index_as=>[:searchable])
        t.publisher(:path=>"teiHeader/oxns:fileDesc/oxns:publicationStmt/oxns:publisher", :index_as=>[:searchable])
        t.teiHeader {
          t.fileDesc {
            t.sourceDesc {
              t.bibl(:index_as=>[:searchable])
            }
          }
        }
        t.bibl(:proxy=>[:teiHeader, :fileDesc, :sourceDesc, :bibl])
      end
    end
  end
end
