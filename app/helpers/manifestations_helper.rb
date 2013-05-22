# -*- encoding : utf-8 -*-

# The helper methods for all manifestations.
# Provides methods for generating representations and relationships generic for the manifestations.
module ManifestationsHelper
  # Creates and adds a SingleFileRepresentation with a TEI file to the manifestation
  # @param tei_metadata The metadata for the TEI file.
  # @param file The uploaded TEI file for the SingleFileRepresentation
  # @param rep_metadata The metadata for the SingleFileRepresentation
  # @param manifestation The manifestation to contain the SingleFileRepresentation
  def add_single_tei_rep(tei_metadata, file, rep_metadata, manifestation)
    tei_file = TeiFile.new(tei_metadata)
    if tei_file.add_file(file)
      tei_file.save!
    else
      return false
    end

    create_as_single_file_rep(tei_file, rep_metadata, manifestation)
  end

  # Creates and adds a SingleFileRepresentation with a basic file to the manifestation
  # @param file The uploaded file for the SingleFileRepresentation
  # @param metadata The metadata for the SingleFileRepresentation
  # @param manifestation The manifestation to contain the SingleFileRepresentation
  def add_single_file_rep(file, metadata, manifestation)
    rep_file = BasicFile.new
    if rep_file.add_file(file)
      rep_file.save!
    else
      return false
    end

    create_as_single_file_rep(rep_file, metadata, manifestation)
  end

  # Creates and adds a OrderedRepresentation with TIFF image files to the manifestation
  # The StructMap for the OrderedRepresentation will be based on the order of the TIFF files.
  # @param files The uploaded TIFF Image files for the OrderedRepresentation
  # @param metadata The metadata for the OrderedRepresentation
  # @param manifestation The manifestation to contain the OrderedRepresentation
  def add_tiff_order_rep(files, metadata, manifestation)
    tiff_files = []

    files.each do |f|
      tiff_file = TiffFile.new
      unless tiff_file.add_file(f)
        return false
      end
      tiff_file.save!

      tiff_files << tiff_file
    end

    create_as_order_rep(tiff_files, metadata, manifestation)
  end

  # Creates and adds a OrderedRepresentation with basic files to the manifestation
  # The StructMap for the OrderedRepresentation will be based on the order of the files.
  # @param files The uploaded files for the OrderedRepresentation
  # @param metadata The metadata for the OrderedRepresentation
  # @param manifestation The manifestation to contain the OrderedRepresentation
  def add_order_rep(files, metadata, manifestation)
    basic_files = []

    files.each do |f|
      file = BasicFile.new
      file.add_file(f)
      file.save!

      basic_files << file
    end

    create_as_order_rep(basic_files, metadata, manifestation)

  end

  # Creates the author relationship between the manifestation and people behind the ids.
  # @param ids The ids for the people who are author of the manifestation
  # @param manifestation The manifestation which is authored by the people behind the ids.
  def add_authors(ids, manifestation)
    if ids.blank? or manifestation.blank?
      return false
    end

    ids.each do |author_pid|
      if author_pid && !author_pid.empty?
        author = Person.find(author_pid)
        manifestation.authors << author
        #author.authored_manifestations << manifestation
        #author.save!
      end
    end
    manifestation.save!
  end

  # Creates the concerned relationship between the manifestation and people behind the ids.
  # @param ids The ids for the people who are concerned about the manifestation
  # @param manifestation The manifestation which is concerns the people behind the ids.
  def add_concerned_people(ids, manifestation)
    ids.each do |person_pid|
      if person_pid && !person_pid.empty?
        person = Person.find(person_pid)
        manifestation.people_concerned << person
      end
    end
    manifestation.save!
  end

  # Creates the structmap for a representation based on the file_name order of the files.
  # @param file_order_string The ordered list of filenames.
  # @param representation The representation containing the files.
  def create_structmap_for_representation(file_order_string, representation)
    file_order = []
    # TODO silly sorting...
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
  # Creates a SingleFileRepresentation with the given file and adds it to the manifestation
  # @param file The file for the SingleFileRepresentation
  # @param metadata The metadata for the SingleFileRepresentation
  # @param manifestation The manifestation to contain the SingleFileRepresentation
  def create_as_single_file_rep(file, metadata, manifestation)
    rep = SingleFileRepresentation.new(metadata)
    rep.files << file
    rep.save!

    add_representation(rep, manifestation)
  end

  # Creates a OrderedRepresentation with the given files and adds it to the manifestation
  # The StructMap for the OrderedRepresentation will be generated based on the order of the files.
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
    if representation == nil || manifestation == nil
      return false
    end

    representation.ie = manifestation
    manifestation.representations << representation
    return representation.save && manifestation.save
  end

  # Generates a StructMap based on a ordered array of files.
  # @param file_order The ordered array of files.
  # @param representation The representation with the structmap
  def generate_structmap(file_order, representation)
    logger.debug 'Generating structmap xml file...'
    logger.debug "structmap_file_order = #{file_order.to_s}"

    ng_doc = representation.techMetadata.ng_xml

    mets_element = ng_doc.at_css 'mets'
    # recreate the structMap element (thus removing all 'div' elements)
    structmap_element = mets_element.at_css 'structMap'
    structmap_element.remove
    structmap_element = Nokogiri::XML::Node.new 'structMap', ng_doc
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

    representation.save!
  end
end
