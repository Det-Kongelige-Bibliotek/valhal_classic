# -*- encoding : utf-8 -*-

# The helper methods for all works.
# Provides methods for generating instances and relationships generic for the works.
module WorkHelper
  include UtilityHelper

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

    create_as_single_file_ins(ins_file, metadata, work)
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

  # Iterate over the agent relations finding the referenced AMU and adding the required relationship to the work for
  # that AMU.
  # @param [Hash] agent_relations
  # @param [Work] work
  def add_agents(agent_relations, work)

    agent_relations.each do |agent_relation_hash|
        agent_relation_hash.each do |agent_relation|
          agent = AuthorityMetadataUnit.find(agent_relation[1]['agentID'])
          if agent_relation[1]['relationshipType'].eql? 'hasTopic'
            work.hasTopic << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasOrigin'
            work.hasOrigin << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasAddressee'
            work.hasAddressee << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasAuthor'
            work.hasAuthor << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasContributor'
            work.hasContributor << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasCreator'
            work.hasCreator << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasOwner'
            work.hasOwner << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasPatron'
            work.hasPatron << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasPerformer'
            work.hasPerformer << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasPhotographer'
            work.hasPhotographer << agent
          elsif agent_relation[1]['relationshipType'].eql? 'hasTranslator'
            work.hasTranslator << agent
          end
        end
    end
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

    WorkHelper.generate_structmap(file_order, instance)
  end

  private
  # Creates a SingleFileInstance with the given basic_files and adds it to the work
  # @param file The file for the SingleFileInstance
  # @param metadata The metadata for the SingleFileInstance
  # @param work The work to contain the SingleFileInstance
  def create_as_single_file_ins(file, metadata, work)
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
    WorkHelper.generate_structmap(files, ins)
    ins.save!

    add_instance(ins, work)
  end

  # Adds a instance to a work
  # TODO: this functionality has been moved to the Work model
  # update callers to use that method instead.
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
  def self.generate_structmap(file_order, instance)
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
