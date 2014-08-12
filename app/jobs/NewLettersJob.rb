class NewLettersJob
  @queue = :brev_ingest

  def self.perform(xmlpath,pdfpath) 
        File.open('test_file.log', 'w') do |f|
      	    f.puts "looking for new xml_file in #{xmlpath}"
    	end
  end
end
