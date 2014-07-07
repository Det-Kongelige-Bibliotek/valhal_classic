# -*- encoding : utf-8 -*-

# The helper methods for all manifestations.
# Provides methods for generating representations and relationships generic for the manifestations.
module ManifestationsHelper
  include UtilityHelper
  # Creates and adds a SingleFileRepresentation with a TEI basic_files to the manifestation
  # @param tei_metadata The metadata for the TEI file.
  # @param file The uploaded TEI file for the SingleFileRepresentation
  # @param rep_metadata The metadata for the SingleFileRepresentation
  # @param manifestation The manifestation to contain the SingleFileRepresentation
  # @return false if operation was unsuccessful
  def add_single_tei_rep(tei_metadata, file, rep_metadata, manifestation)
    tei_file = TeiFile.new(tei_metadata)
    if tei_file.add_file(file, nil)
      tei_file.save!
    else
      return false
    end

    create_as_single_file_rep(tei_file, rep_metadata, manifestation)
  end

  # Creates and adds a SingleFileRepresentation with a basic basic_files to the manifestation
  # @param file The uploaded file for the SingleFileRepresentation
  # @param metadata The metadata for the SingleFileRepresentation
  # @param skip_fits boolean value determining whether to skip file characterisation or not
  # @param manifestation The manifestation to contain the SingleFileRepresentation
  def add_single_file_rep(file, metadata, skip_fits, manifestation)
    rep_file = BasicFile.new
    if rep_file.add_file(file, skip_fits)
      rep_file.save!
    else
      return false
    end

    create_as_single_file_rep(rep_file, metadata, manifestation)
  end

  # Creates and adds a OrderedRepresentation with TIFF image basic_files to the manifestation
  # The StructMap for the OrderedRepresentation will be based on the order of the TIFF basic_files.
  # @param files The uploaded TIFF Image files for the OrderedRepresentation
  # @param metadata The metadata for the OrderedRepresentation
  # @param skip_fits boolean value determining whether to skip file characterisation or not
  # @param manifestation The manifestation to contain the OrderedRepresentation
  # @return false if operation was unsuccessful
  def add_ordered_file_rep(files, metadata, skip_fits, manifestation)
    basic_files = []

    files.each do |f|
      bf = BasicFile.new
      unless bf.add_file(f, skip_fits)
        return false
      end
      bf.save!

      basic_files << bf
    end

    create_as_order_rep(basic_files, metadata, manifestation)
  end

  # Creates and adds a OrderedRepresentation with basic basic_files to the manifestation
  # The StructMap for the OrderedRepresentation will be based on the order of the basic_files.
  # @param files The uploaded files for the OrderedRepresentation
  # @param metadata The metadata for the OrderedRepresentation
  # @param manifestation The manifestation to contain the OrderedRepresentation
  def add_order_rep(files, metadata, manifestation)
    basic_files = []

    files.each do |f|
      file = BasicFile.new
      file.add_file(f, nil)
      file.save!

      basic_files << file
    end

    create_as_order_rep(basic_files, metadata, manifestation)

  end

  # Creates the author relationship between the manifestation and people behind the ids.
  # @param ids The ids for the people who are author of the manifestation
  # @param manifestation The manifestation which is authored by the people behind the ids.
  def set_authors(ids, manifestation)
    if ids.blank? or manifestation.blank? or contentless_array?(ids)
      return false
    end

    manifestation.clear_authors
    ids.each do |author_pid|
      if author_pid && !author_pid.empty?
        author = Person.find(author_pid)
        manifestation.authors << author
      end
    end
    manifestation.save!
  end

  # Creates the concerned relationship between the manifestation and people behind the ids.
  # @param ids The ids for the people who are concerned about the manifestation
  # @param manifestation The manifestation which concerns the people behind the ids.
  def set_concerned_people(ids, manifestation)
    if ids.blank? or manifestation.blank? or contentless_array?(ids)
      return false
    end

    manifestation.clear_concerned_people
    ids.each do |person_pid|
      if person_pid && !person_pid.empty?
        person = Person.find(person_pid)
        manifestation.people_concerned << person
      end
    end
    manifestation.save!
  end

  # Creates the structmap for a representation based on the file_name order of the basic_files.
  # @param file_order_string The ordered list of filenames.
  # @param representation The representation containing the files.
  def create_structmap_for_representation(file_order_string, representation)
    file_order = []
    file_order_string.split(',').each do |f|
      representation.files.each do |file|
        if file.original_filename == f
          file_order << file
          break
        end
      end
    end

    generate_structmap(file_order, representation)
  end

  private
  # Creates a SingleFileRepresentation with the given basic_files and adds it to the manifestation
  # @param file The file for the SingleFileRepresentation
  # @param metadata The metadata for the SingleFileRepresentation
  # @param manifestation The manifestation to contain the SingleFileRepresentation
  def create_as_single_file_rep(file, metadata, manifestation)
    rep = SingleFileRepresentation.new(metadata)
    rep.files << file
    rep.save!

    add_representation(rep, manifestation)
  end

  # Creates a OrderedRepresentation with the given basic_files and adds it to the manifestation
  # The StructMap for the OrderedRepresentation will be generated based on the order of the basic_files.
  # @param files The ordered array of files for the ordered representation
  # @param metadata The metadata for the OrderedRepresentation
  # @param manifestation The manifestation to contain the OrderedRepresentation
  def create_as_order_rep(files, metadata, manifestation)
    rep = OrderedRepresentation.new(metadata)
    rep.files << files
    generate_structmap(files, rep)
    rep.save!

    add_representation(rep, manifestation)
  end

  # Adds a representation to a manifestation
  # @param representation The representation to be added to the manifestation
  # @param manifestation The manifestation to have the representation added.
  def add_representation(representation, manifestation)
    representation.ie = manifestation
    manifestation.representations << representation
    return representation.save && manifestation.save
  end

  # Generates a StructMap based on a ordered array of basic_files.
  # @param file_order The ordered array of files.
  # @param representation The ordered representation with the structmap
  def generate_structmap(file_order, representation)
    logger.debug 'Generating structmap xml basic_files...'
    logger.debug "structmap_file_order = #{file_order.to_s}"

    ng_doc = representation.techMetadata.ng_xml

    mets_element = ng_doc.at_css 'mets'
    # recreate the structMap element (thus removing all 'div' elements)
    structmap_element = mets_element.at_css 'structMap'
    structmap_element.remove
    structmap_element = Nokogiri::XML::Node.new('structMap', ng_doc)
    mets_element.add_child(structmap_element)

    count = 1
    #for each filename create the required XML elements and attributes
    file_order.each do |file|
      div_element = Nokogiri::XML::Node.new 'div', ng_doc
      fptr_element = Nokogiri::XML::Node.new 'fptr', ng_doc
      fptr_element.set_attribute('FILEID', file.uuid.to_s)
      div_element.add_child(fptr_element)
      div_element.set_attribute('ORDER', count.to_s)
      div_element.set_attribute('ID', file.original_filename.to_s)
      structmap_element.add_child(div_element)
      count = count + 1
    end

    representation.techMetadata.ng_xml = ng_doc
    representation.techMetadata.ng_xml.encoding = 'UTF-8'
    representation.save!
  end
end
