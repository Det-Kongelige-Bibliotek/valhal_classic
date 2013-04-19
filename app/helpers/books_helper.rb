# -*- encoding : utf-8 -*-
module BooksHelper
  #Helper function for generating a METS structmap
  # @param [String] file_order_string
  # @param [BookTiffRepresentation] representation
  def generate_structmap(file_order_string, representation)
    logger.debug 'Generating structmap xml file...'
    logger.debug "structmap_file_order = #{file_order_string.to_s}"
    structmap = StructMap.new
    ng_doc = structmap.techMetadata.ng_xml

    file_names = file_order_string.split(',')

    structmap_element = ng_doc.at_css 'structMap'
    #remove the empty div element populated on calling new
    dummy_div = ng_doc.at_css "div"
    dummy_div.remove

    count = 1
    #for each filename create the required XML elements and attributes
    file_names.each do |file_name|
      div_element = Nokogiri::XML::Node.new "div", ng_doc
      fptr_element = Nokogiri::XML::Node.new "fptr", ng_doc
      fptr_element.set_attribute('FILEID', "#{file_name}.tif")
      div_element.add_child(fptr_element)
      div_element.set_attribute('ORDER', count.to_s)
      structmap_element.add_child(div_element)
      count = count + 1
    end

    logger.debug "Structmap before replacing filenames with UUIDs"
    logger.debug ng_doc.to_s

    #Put the UUIDs for each tif file in a hash using the original filename as the key for each UUID
    tiffs_hash = Hash.new
    representation.files.each do |tiff_basic_file|
      tiffs_hash[tiff_basic_file.original_filename] = tiff_basic_file.uuid
    end

    logger.debug tiffs_hash.inspect
    #using the order of the filenames in the structmap, get the corresponding UUID from the hashmap and replace the
    #filename in the structmap with the UUID

    #need a list of the fptr FILEID attributes in the order they appear in the doc
    ng_doc.xpath("//@FILEID").each do |file_id|
      logger.debug "file_id: #{file_id}"
      logger.debug "tiffs_hash[file_id.to_s].to_s: #{tiffs_hash[file_id.to_s].to_s}"
      file_id.content = tiffs_hash[file_id.to_s].to_s
    end

    logger.debug "Structmap after replacing filenames with UUIDs"
    logger.debug ng_doc.to_s

    representation.structmap << structmap
    representation.save!
    structmap
  end
end