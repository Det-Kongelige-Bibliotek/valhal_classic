# -*- encoding : utf-8 -*-

# The helper methods for all works.
# Provides methods for generating instances and relationships generic for the works.
module WorkHelper
  include UtilityHelper
  # Creates and adds a SingleFileInstance with a TEI basic_files to the work
  # @param tei_metadata The metadata for the TEI file.
  # @param file The uploaded TEI file for the SingleFileInstance
  # @param ins_metadata The metadata for the SingleFileInstance
  # @param work The work to contain the SingleFileInstance
  # @return false if operation was unsuccessful
  def add_single_tei_ins(tei_metadata, file, ins_metadata, work)
    tei_file = TeiFile.new(tei_metadata)
    if tei_file.add_file(file, nil)
      tei_file.save!
    else
      return false
    end

    create_as_single_file_inc(tei_file, ins_metadata, work)
  end

  # Creates and adds a SingleFileInstance with a basic basic_files to the work
  # @param file The uploaded file for the SingleFileInstance
  # @param metadata The metadata for the SingleFileInstance
  # @param skip_fits boolean value determining whether to skip file characterisation or not
  # @param work The work to contain the SingleFileInstance
  def add_single_file_ins(file, metadata, skip_fits, work)
    ins_file = BasicFile.new
    if ins_file.add_file(file, skip_fits)
      ins_file.save!
    else
      return false
    end

    create_as_single_file_inc(ins_file, metadata, work)
  end

  # Creates and adds a OrderedInstance with basic_files to the work
  # The StructMap for the OrderedInstance will be based on the order of the TIFF basic_files.
  # @param files The uploaded TIFF Image files for the OrderedInstance
  # @param metadata The metadata for the OrderedInstance
  # @param skip_fits boolean value determining whether to skip file characterisation or not
  # @param work The work to contain the OrderedInstance
  # @return false if operation was unsuccessful
  def add_ordered_file_ins(files, metadata, skip_fits, work)
    basic_files = []

    files.each do |f|
      bf = BasicFile.new
      unless bf.add_file(f, skip_fits)
        return false
      end
      bf.save!

      basic_files << bf
    end

    create_as_order_ins(basic_files, metadata, work)
  end

  # Creates and adds a OrderedInstance with basic basic_files to the work
  # The StructMap for the OrderedInstance will be based on the order of the basic_files.
  # @param files The uploaded files for the OrderedInstance
  # @param metadata The metadata for the OrderedInstance
  # @param work The work to contain the OrderedInstance
  def add_order_ins(files, metadata, work)
    basic_files = []

    files.each do |f|
      file = BasicFile.new
      file.add_file(f, nil)
      file.save!

      basic_files << file
    end

    create_as_order_ins(basic_files, metadata, work)

  end

  # Creates the author relationship between the work and people behind the ids.
  # @param ids The ids for the people who are author of the work
  # @param work The work which is authored by the people behind the ids.
  def set_authors(ids, work)
    if ids.blank? or work.blank? or contentless_array?(ids)
      return false
    end

    work.clear_authors
    ids.each do |author_pid|
      if author_pid && !author_pid.empty?
        author = AuthorityMetadataUnit.find(author_pid)
        work.hasAuthor << author
      end
    end
    work.save!
  end

  # Creates the concerned relationship between the work and people behind the ids.
  # @param ids The ids for the people who are concerned about the work
  # @param work The work which concerns the people behind the ids.
  def set_concerned_people(ids, work)
    if ids.blank? or work.blank? or contentless_array?(ids)
      return false
    end

    work.clear_concerned_people
    ids.each do |person_pid|
      if person_pid && !person_pid.empty?
        person = AuthorityMetadataUnit.find(person_pid)
        work.hasTopic << person
      end
    end
    work.save!
  end

  # Creates the structmap for a instance based on the file_name order of the basic_files.
  # @param file_order_string The ordered list of filenames.
  # @param instance The instance containing the files.
  def create_structmap_for_instance(file_order_string, instance)
    file_order = []
    file_order_string.split(',').each do |f|
      instance.files.each do |file|
        if file.original_filename == f
          file_order << file
          break
        end
      end
    end

    generate_structmap(file_order, instance)
  end

  private
  # Creates a SingleFileInstance with the given basic_files and adds it to the work
  # @param file The file for the SingleFileInstance
  # @param metadata The metadata for the SingleFileInstance
  # @param work The work to contain the SingleFileInstance
  def create_as_single_file_inc(file, metadata, work)
    ins = SingleFileInstance.new(metadata)
    ins.files << file
    ins.save!

    add_instance(ins, work)
  end

  # Creates a OrderedInstance with the given basic_files and adds it to the work
  # The StructMap for the OrderedInstance will be generated based on the order of the basic_files.
  # @param files The ordered array of files for the ordered instance
  # @param metadata The metadata for the OrderedInstance
  # @param work The work to contain the OrderedInstance
  def create_as_order_ins(files, metadata, work)
    ins = OrderedInstance.new(metadata)
    ins.files << files
    generate_structmap(files, ins)
    ins.save!

    add_instance(ins, work)
  end

  # Adds a instance to a work
  # @param instance The instance to be added to the work
  # @param work The work to have the instance added.
  def add_instance(instance, work)
    instance.ie = work
    work.instances << instance
    return instance.save && work.save
  end

  # Generates a StructMap based on a ordered array of basic_files.
  # @param file_order The ordered array of files.
  # @param instance The ordered instance with the structmap
  def generate_structmap(file_order, instance)
    logger.debug 'Generating structmap xml basic_files...'
    logger.debug "structmap_file_order = #{file_order.to_s}"

    ng_doc = instance.techMetadata.ng_xml

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

    instance.techMetadata.ng_xml = ng_doc
    instance.techMetadata.ng_xml.encoding = 'UTF-8'
    instance.save!
  end
end
