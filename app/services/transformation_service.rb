# -*- encoding : utf-8 -*-
# Responsible for transforming from internal descriptive metadata format with authority-metadata into MODS.
class TransformationService
  # Transforms the descriptive metadata for a Work or an Instance into MODS.
  # If the Instance belongs to a Work, then the metadata for the Work will be used along the metadata for the Instance
  # to create the MODS.
  # @param element The Work or Instance element to have its descriptive metadata transformed into MODS.
  # @return The descriptive metadata for the element in MODS.
  def self.transform_to_mods(element)
    xml = extract_metadata(element)
    doc =  Nokogiri::XML::Document.parse(xml)

    valhal2mods = Nokogiri::XSLT(File.read("#{Rails.root}/xslt/Valhal2MODS.xsl"))
    valhal2mods.transform(doc)
  end

  # Creates Valhal elements Work and Instance from a MODS record.
  # Will also create the needed authority metadata units.
  # @param mods The MODS record to create the Work and Instance from.
  # @return The Work created from the MODS.
  def self.create_from_mods(mods)
    # TODO

    puts mods
  end

  private
  # Extract the descriptive metadata for the element in a simple XML structure.
  #
  # Adds the descriptive metadata from Work for Instance (unless the instance does not have a Work).
  # @param The element to extract the metadata from.
  # @return The metadata in the simple XML format, ready to be transformed.
  def self.extract_metadata(element)
    res = "<metadata>\n"
    res += element.descMetadata.content
    # TODO change from test-class into real class.
    #if element.is_a?(Instance) && !element.work.nil?
    if element.is_a?(InstanceTestClass) && !element.work.nil?
      res += element.work.descMetadata.content
      res += self.extract_relations_in_xml(element.work)
    end
    res += self.extract_relations_in_xml(element)
    res += "</metadata>\n"
    res
  end

  # Extracts the relations to AuthorityMetadataUnits in a simple XML format.
  # Each relation looks like this:
  # <$relation_type>
  #   <type>$type</type>
  #   <value>$value</value>
  #   <reference>$reference</reference>
  # </$relation_type>
  #
  # @param element
  # @return The relations extracted into the simple XML format.
  def self.extract_relations_in_xml(element)
    res = "\n"
    element.get_relations.each do |k,v|
      v.each do |amu|
        res += "  <#{k}>\n"
        res += "    <value>#{amu.value}</value>\n"
        res += "    <type>#{amu.type}</type>\n"
        amu.reference.each do |r|
          res += "    <reference>#{r}</reference>\n"
        end
        res += "  </#{k}>\n"
      end
    end
    res
  end
end