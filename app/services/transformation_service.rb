# -*- encoding : utf-8 -*-
# Responsible for transforming from internal descriptive metadata format with authority-metadata into MODS.
class TransformationService
  include XmlHelper

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
  # @param files The files which should be used for creating the instance. If more than 1 file, then a OrderedInstance
  # is created, otherwise a SingleFileInstance
  # @return The Work created from the MODS.
  def self.create_from_mods(mods, files)
    fields_for_work, fields_for_instance, metadata_objects = extract_mods_fields_as_hashes(mods)

    w = Work.create(fields_for_work)
    w.alternativeTitle = metadata_objects['alternativeTitle']
    w.identifier = metadata_objects['identifier']
    w.language = metadata_objects['language']
    w.note = metadata_objects['note']

    if files.length > 1
      i = OrderedInstance.create(fields_for_instance)
    else
      i = SingleFileInstance.create(fields_for_instance)
    end

    i.ie = w
    w.instances << i
    i.save
    w.save

    return w, i
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

  # Extracts the MODS fields which is used in Valhal, as a Hash map.
  # @param mods The MODS record to extract the Valhal fields from.
  # @return A hash containing the Valhal fields from the MODS record.
  def self.extract_mods_fields_as_hashes(mods)
    mods_namespace_for_css = XmlHelper.extract_namespace_prefix(mods, 'http://www.loc.gov/mods/v3')
    mods_namespace_for_css += '|' unless mods_namespace_for_css.blank?

    fields_for_work = Hash.new
    fields_for_instance = Hash.new
    metadata_objects = Hash.new
    mods.css("//#{mods_namespace_for_css}mods").each do |n|
      # work single field workType (Any 'genre' elements with the 'type' attribute)
      n.css("#{mods_namespace_for_css}genre").each do |m|
        if m.attributes.keys.include? 'type'
          fields_for_work['workType'] = m.text
        end
      end
      # work multiple fields genre (ignores the one with 'type' attribute)
      n.css("#{mods_namespace_for_css}genre").each do |m|
        unless m.attributes.keys.include? 'type'
          fields_for_work['genre'].nil? ? fields_for_work['genre'] = [m.text] : fields_for_work['genre'] << m.text
        end
      end
      # instance single field shelfLocator (location)
      n.css("#{mods_namespace_for_css}location/#{mods_namespace_for_css}shelfLocator").each do |m|
        fields_for_instance['shelfLocator'] = m.text
      end
      # work single field dateCreated
      n.css("#{mods_namespace_for_css}originInfo/#{mods_namespace_for_css}dateCreated").each do |m|
        fields_for_work['dateCreated'] = m.text
      end
      # instance single field dateIssued
      n.css("#{mods_namespace_for_css}originInfo/#{mods_namespace_for_css}dateIssued").each do |m|
        fields_for_instance['dateIssued'] = m.text
      end
      # work multiple fields dateOther
      n.css("#{mods_namespace_for_css}originInfo/#{mods_namespace_for_css}dateOther").each do |m|
        fields_for_work['dateOther'].nil? ? fields_for_work['dateOther'] = [m.text] : fields_for_work['dateOther'] << m.text
      end
      # instance multiple fields physicalDescription.form
      n.css("#{mods_namespace_for_css}physicalDescription/#{mods_namespace_for_css}form").each do |m|
        fields_for_instance['physicalDescriptionForm'].nil? ? fields_for_instance['physicalDescriptionForm'] = [m.text] : fields_for_instance['physicalDescriptionForm'] << m.text
      end
      # instance multiple fields physicalDescription.note
      n.css("#{mods_namespace_for_css}physicalDescription/#{mods_namespace_for_css}note").each do |m|
        fields_for_instance['physicalDescriptionNote'].nil? ? fields_for_instance['physicalDescriptionNote'] = [m.text] : fields_for_instance['physicalDescriptionNote'] << m.text
      end
      # work multiple fields languageOfCataloging
      n.css("#{mods_namespace_for_css}recordInfo/#{mods_namespace_for_css}languageOfCataloging/#{mods_namespace_for_css}languageTerm").each do |m|
        fields_for_work['languageOfCataloging'].nil? ? fields_for_work['languageOfCataloging'] = [m.text] : fields_for_work['languageOfCataloging'] << m.text
      end
      # work single field recordOriginInfo
      n.css("#{mods_namespace_for_css}recordInfo/#{mods_namespace_for_css}recordOrigin").each do |m|
        fields_for_work['recordOriginInfo'] = m.text
      end
      # work single field cartographicsScale
      n.css("#{mods_namespace_for_css}subject/#{mods_namespace_for_css}cartographics/#{mods_namespace_for_css}scale").each do |m|
        fields_for_work['cartographicsScale'] = m.text
      end
      # single field cartographicsCoordinates
      n.css("#{mods_namespace_for_css}subject/#{mods_namespace_for_css}cartographics/#{mods_namespace_for_css}coordinates").each do |m|
        fields_for_work['cartographicsCoordinates'] = m.text
      end
      # multitple fields topic (any subject/topic, where the subject does not have a 'displayLabel' for authorityMetadata)
      n.css("#{mods_namespace_for_css}subject").each do |m|
        unless (m.attributes.keys.include?('displayLabel') && (m.attributes['displayLabel'].value == 'Concept' || m.attributes['displayLabel'].value == 'Event' || m.attributes['displayLabel'].value == 'PhysicalThing'))
          m.css("/#{mods_namespace_for_css}topic").each do |l|
            fields_for_work['topic'].nil? ? fields_for_work['topic'] = [l.text] : fields_for_work['topic'] << l.text
          end
        end
      end
      # single fields title & subTitle
      n.css("#{mods_namespace_for_css}titleInfo").each do |m|
        unless m.attributes.keys.include?('type') || m.attributes.keys.include?('otherType')
          m.css("#{mods_namespace_for_css}title").each do |l|
            fields_for_work['title'].nil? ? fields_for_work['title'] = [l.text] : fields_for_work['title'] << l.text
          end
          m.css("#{mods_namespace_for_css}subTitle").each do |l|
            fields_for_work['subTitle'].nil? ? fields_for_work['subTitle'] = [l.text] : fields_for_work['subTitle'] << l.text
          end
        end
      end
      # single fields typeOfResource and typeOfResourceLabel
      n.css("#{mods_namespace_for_css}typeOfResource").each do |m|
        fields_for_work['typeOfResource'] = m.text
        fields_for_work['typeOfResourceLabel'] = m.attributes['displayLabel'].value unless m.attributes['displayLabel'].nil?
      end

      # identifier objects
      n.css("#{mods_namespace_for_css}identifier").each do |m|
        id = Hash.new
        id['value'] = m.text
        id['displayLabel'] = m.attributes['displayLabel'].value unless m.attributes['displayLabel'].nil?

        metadata_objects['identifier'].nil? ? metadata_objects['identifier'] = [id] : metadata_objects['identifier'] << id
      end
      # language objects
      n.css("#{mods_namespace_for_css}language/#{mods_namespace_for_css}languageTerm").each do |m|
        lang = Hash.new
        lang['value'] = m.text
        lang['authorityURI'] = m.attributes['authorityURI'].value unless m.attributes['authorityURI'].nil?

        metadata_objects['language'].nil? ? metadata_objects['language'] = [lang] : metadata_objects['language'] << lang
      end
      # note objects
      n.css("#{mods_namespace_for_css}note").each do |m|
        note = Hash.new
        note['value'] = m.text
        note['displayLabel'] = m.attributes['displayLabel'].value unless m.attributes['displayLabel'].nil?

        metadata_objects['note'].nil? ? metadata_objects['note'] = [note] : metadata_objects['note'] << note
      end
      # alternativeTitle objects
      n.css("#{mods_namespace_for_css}titleInfo").each do |m|
        if m.attributes.keys.include?('type') || m.attributes.keys.include?('otherType')
          at = Hash.new
          m.css("#{mods_namespace_for_css}title").each do |l|
            at['title'] = l.text
          end
          m.css("#{mods_namespace_for_css}subTitle").each do |l|
            at['subTitle'] = l.text
          end
          at['displayLabel'] = m.attributes['displayLabel'].value unless m.attributes['displayLabel'].nil?
          at['type'] = m.attributes['type'].nil? ? 'other' : m.attributes['type'].value
          at['lang'] = m.attributes['lang'].value unless m.attributes['lang'].nil?

          metadata_objects['alternativeTitle'].nil? ? metadata_objects['alternativeTitle'] = [at] : metadata_objects['alternativeTitle'] << at
        end
      end
    end

    return fields_for_work, fields_for_instance, metadata_objects
  end
end