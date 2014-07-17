# -*- encoding : utf-8 -*-

# Finds the different AuthorityMetadataUnits.
# Also has method for extracting metadata units from MODS records.
module AMUFinderService
  include StringHelper
  include XmlHelper

  # Finds or creates a AuthorityMetadataUnit with type agent/person.
  # If several agent/person exists with the same name, then it only takes the first.
  # @param name The value of the agent/person
  # @param ref The optional reference, if the agent has to be created.
  # @return The first found agent/person with the given name, or a newly created agent/person with the given name.
  def self.find_or_create_agent_person(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/person\" && amu_value_ssi:\"#{remove_special_characters(name)}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'agent/person', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Finds or creates a AuthorityMetadataUnit with type agent/organization.
  # If several agent/organization exists with the same name, then it only takes the first.
  # @param name The value of the agent/organization
  # @param ref The optional reference, if the agent has to be created.
  # @return The first found agent/organization with the given name, or a newly created agent/organization with the given name.
  def self.find_or_create_agent_organization(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/organization\" && amu_value_ssi:\"#{remove_special_characters(name)}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'agent/organization', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Method for finding an agent which can be either a agent/person or agent/organization.
  # If no such agent is found, then it is created as a person.
  # If both agent/person and agent/organization exists with the same name, then it takes the first agent/person.
  # If no agent/person, but several agent/organization is found, then it takes the first agent/organization.
  # @param name The name of the agent.
  # @param ref The optional reference, if the agent has to be created.
  # @return Either the first found existing agent (either agent/person or agent/organization), or the newly created agent/person,
  def self.find_agent_or_create_agent_person(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/person\" && amu_value_ssi:\"#{remove_special_characters(name)}\"").first
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/organization\" && amu_value_ssi:\"#{remove_special_characters(name)}\"").first if search.nil?
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'agent/person', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Finds or creates an AuthorityMetadataUnit of the type concept with the given name.
  # If several concepts with the same name is found, then it takes the first one.
  # @param name The name of the concept.
  # @param ref The optional reference, if the concept has to be created.
  # @return Either the existing concept or the newly created one.
  def self.find_or_create_concept(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"concept\" && amu_value_ssi:\"#{remove_special_characters(name)}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'concept', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Finds or creates an AuthorityMetadataUnit of the type event with the given name.
  # If several events with the same name is found, then it takes the first one.
  # @param name The name of the event.
  # @param ref The optional reference, if the event has to be created.
  # @return Either the existing event or the newly created one.
  def self.find_or_create_event(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"event\" && amu_value_ssi:\"#{remove_special_characters(name)}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'event', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Finds or creates an AuthorityMetadataUnit of the type physicalThing with the given name.
  # If several physicalThings with the same name is found, then it takes the first one.
  # @param name The name of the physicalThing.
  # @param ref The optional reference, if the physicalThing has to be created.
  # @return Either the existing physicalThing or the newly created one.
  def self.find_or_create_physical_thing(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"physicalThing\" && amu_value_ssi:\"#{remove_special_characters(name)}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'physicalThing', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Finds or creates an AuthorityMetadataUnit of the type place with the given name.
  # If several places with the same name is found, then it takes the first one.
  # @param name The name of the place.
  # @param ref The optional reference, if the place has to be created.
  # @return Either the existing place or the newly created one.
  def self.find_or_create_place(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"place\" && amu_value_ssi:\"#{remove_special_characters(name)}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'place', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Extract the agents and their relations from a MODS record,
  # The agents are either agent/organization or agent/person depending on type attribute on the name element.
  # Does not create a new agent, if a similar one already exists with the same name. Then refers to the existing one.
  # Extracts agents from the MODS paths: mods/name, mods/subject/name, and mods/originInfo/publisher.
  # @param mods The MODS to extract the agent from.
  # @return A hash between the agents and their relation.
  def self.find_amus_with_relation_from_mods(mods)
    if(mods.is_a?(String))
      xml_doc = Nokogiri::XML(mods)
    else
      xml_doc = mods
    end

    namespace = XmlHelper.extract_namespace_prefix(xml_doc, 'http://www.loc.gov/mods/v3')
    unless namespace.blank?
      namespace += '|'
    end
    res = Hash.new
    res.merge! extract_agents_from_mods_name_with_namespace(xml_doc, namespace)
    res.merge! extract_agents_from_mods_subject_with_namespace(xml_doc, namespace)
    res.merge! extract_agents_from_mods_publisher_with_namespace(xml_doc, namespace)
    res.merge! extract_amus_from_mods_subject_with_namespace(xml_doc, namespace)
    res.merge! extract_place_from_mods_geographic_with_namespace(xml_doc, namespace)
    res.merge! extract_place_from_mods_origin_place_with_namespace(xml_doc, namespace)
  end

  private
  # Extracts the agents from a MODS document at the path 'mods/name'
  # The roles of these names are used for the relations.
  # @param xml_doc The MODS document to extract the agents from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/name'
  def self.extract_agents_from_mods_name_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'name' (without namespace prefix) with relation from role (or 'Unknown' if not set)
    xml_doc.css("//#{namespace}mods/#{namespace}name").each do |n|
      name = combine_elements(n.css("#{namespace}namePart"))
      unless name.blank?
        # Handle different if it is a corporate -> organization.
        if n.attr('type') == 'corporate'
          agent = find_or_create_agent_organization(name, n.attr('authorityURI'))
        else
          agent = find_or_create_agent_person(name, n.attr('authorityURI'))
        end
        res[agent] = add_to_array(res[agent], n.css("#{namespace}role #{namespace}roleTerm"))
      end
    end
    res
  end
  # Extracts the agents from a MODS document at the path 'mods/subject/name'
  # The roles of these names are used for the relations.
  # @param xml_doc The MODS document to extract the agents from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/subject/name'
  def self.extract_agents_from_mods_subject_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'subject/name' (without namespace prefix) with relation 'Topic' (ignores role)
    xml_doc.css("//#{namespace}mods/#{namespace}subject/#{namespace}name").each do |n|
      name = combine_elements(n.css("#{namespace}namePart"))
      unless name.blank?
        # Handle different if it is a corporate -> organization.
        if n.attr('type') == 'corporate'
          agent = find_or_create_agent_organization(name, n.attr('authorityURI'))
        else
          agent = find_or_create_agent_person(name, n.attr('authorityURI'))
        end
        res[agent] = add_to_array(res[agent], 'Topic')
      end
    end
    res
  end
  # Extracts the agents from a MODS document at the path 'mods/originInfo/publisher'.
  # They have the publisher relations.
  # @param xml_doc The MODS document to extract the agents from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/originInfo/publisher'
  def self.extract_agents_from_mods_publisher_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'subject/name' (without namespace prefix) with relation 'Topic' (ignores role)
    xml_doc.css("//#{namespace}mods/#{namespace}originInfo/#{namespace}publisher").each do |n|
      agent = find_agent_or_create_agent_person(n.text, nil)
      res[agent] = add_to_array(res[agent], 'Publisher')
    end
    res
  end
  # Extracts the AMUs from a MODS document at the path 'mods/subject/topic'.
  # They have the Topic relations.
  # Uses the mods/subject@displayLabel to distinguish between types of AMU (not case sensitive).
  # @param xml_doc The MODS document to extract the AMUs from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/subject/topic'
  def self.extract_amus_from_mods_subject_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'subject' and check the type.
    xml_doc.css("//#{namespace}mods/#{namespace}subject").each do |n|
      if n.attr('displayLabel') && n.attr('displayLabel').downcase == 'concept'
        n.css("#{namespace}topic").each do |topic|
          unless topic.text.blank?
            agent = find_or_create_concept(topic.text, topic.attr('authorityURI'))
            res[agent] = add_to_array(res[agent], 'Topic')
          end
        end
      elsif n.attr('displayLabel') && n.attr('displayLabel').downcase == 'event'
        n.css("#{namespace}topic").each do |topic|
          unless topic.text.blank?
            agent = find_or_create_event(topic.text, topic.attr('authorityURI'))
            res[agent] = add_to_array(res[agent], 'Topic')
          end
        end
      elsif n.attr('displayLabel') && n.attr('displayLabel').downcase == 'physicalthing'
        n.css("#{namespace}topic").each do |topic|
          unless topic.text.blank?
            agent = find_or_create_physical_thing(topic.text, topic.attr('authorityURI'))
            res[agent] = add_to_array(res[agent], 'Topic')
          end
        end
      end
    end
    res
  end
  # Extracts the places from a MODS document at the path 'mods/subject/geographic'.
  # They have the Topic relations.
  # @param xml_doc The MODS document to extract the places from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/subject/geographic'
  def self.extract_place_from_mods_geographic_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'subject' and check the type.
    xml_doc.css("//#{namespace}mods/#{namespace}subject/#{namespace}geographic").each do |n|
      unless n.text.blank?
        agent = find_or_create_place(n.text, n.attr('authorityURI'))
        res[agent] = add_to_array(res[agent], 'Topic')
      end
    end
    res
  end
  # Extracts the places from a MODS document at the path 'mods/originInfo/place'.
  # They have the Origin relations.
  # @param xml_doc The MODS document to extract the places from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/originInfo/place'
  def self.extract_place_from_mods_origin_place_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'subject' and check the type.
    xml_doc.css("//#{namespace}mods/#{namespace}originInfo/#{namespace}place/#{namespace}placeTerm").each do |n|
      unless n.text.blank?
        agent = find_or_create_place(n.text, n.attr('authorityURI'))
        res[agent] = add_to_array(res[agent], 'Origin')
      end
    end
    res
  end

  # Adds a value to the array.
  # If it is a XML TEXT element, then it is extracted.
  # If it is nil or empty, then it uses the value 'Unknown' instead
  # @param array The array to add the value to.
  # @param value The value to add to the array (String, XML TEXT element or nil)
  # @return The array with the new value. If the array is nil, then it is created.
  def self.add_to_array(array, value)
    if value.nil? || value.empty?
      value = 'Unknown'
    elsif value.is_a? String
      # keep the value
    else
      value = value.first.text
    end

    if array.nil?
      [value]
    else
      array << value
    end
  end

  # Combines several 'text' elements into a single string.
  # Space separates the different elements, and removes any trailing whitespaces.
  # @param elements The elements to extract.
  # @return The combined text elements.
  def self.combine_elements(elements)
    res = ''
    elements.reverse.each do |e|
      res += "#{e.text} "
    end
    res.rstrip
  end
end
