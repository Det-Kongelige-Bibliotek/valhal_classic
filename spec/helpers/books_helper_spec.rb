require 'spec_helper'

describe BooksHelper do
  describe "generate_structmap" do
    it 'should generate a structmap' do
      pending "TODO Does not work! Is the method used any more?"
      file_order = "arre1fm001,arre1fm002,arre1fm003,arre1fm004,arre1fm005,arre1fm006"
      tiff_representation = create_tiff_representation(6)
      structmap = generate_structmap(file_order, tiff_representation)
      structmap.should_not be_nil

      #check each UUID in the structmap matches its place in the order of the filenames
      file_names = file_order.split(',')

      file_names.each do |file_name|
        #find the UUID in the files array
        count = 1
        tiff_representation.files.each do |basic_tiff_file|
          if basic_tiff_file.original_filename.eql? file_name
            uuid = basic_tiff_file.uuid
            ng_xml_doc = structmap.techMetadata.ng_xml
            ng_xml_doc.xpath("/mets:mets/mets:structMap/mets:div[#{count}]/mets:fptr/@FILEID", {"mets" => "http://www.loc.gov/METS/"}).first.content.should == uuid
          end
          count = count + 1
        end
      end
    end
  end
end