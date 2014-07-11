# -*- encoding : utf-8 -*-

# Finds the different
module AMUFinderService

  # Finds or creates a AuthorityMetadataUnit with type agent/person.
  # @param name The value of the agent/person
  # @return The agent/person with the given name.
  def find_or_create_agent_person(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/person\" && amu_value_ssi:\"#{name}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'agent/person', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Finds or creates a AuthorityMetadataUnit with type agent/organization.
  # @param name The value of the agent/organization
  # @return The agent/organization with the given name.
  def find_or_create_agent_organization(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/organization\" && amu_value_ssi:\"#{name}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'agent/organization', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Method for finding an agent which can be either a agent/person or agent/organization.
  # If no such agent is found, then it is created as a person.
  # @param name The name of the agent.
  # @return Either the existing agent (either agent/organization or agent/person), or the newly created agent/person,
  def find_agent_or_create_agent_person(name, ref)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/person\" && amu_value_ssi:\"#{name}\"").first
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/organization\" && amu_value_ssi:\"#{name}\"").first if search.nil?
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'agent/person', :value => name, :reference => ref)
    else
      AuthorityMetadataUnit.find(search['id'])
    end

  end

  # Extract the agents and their relations from a MODS record,
  # The agents are either agent/organization or agent/person depending on type attribute on the name element.
  # Does not create a new agent, if a similar one already exists with the same name. Then just use existing one.
  # TODO: Only extracts from the 'name' and 'subject/name' node.
  # @param mods The MODS to extract the agent from.
  # @return A hash between the agents and their relation.
  def find_agents_with_relation_from_mods(mods)
    xml_doc = Nokogiri::XML(mods)

    namespace = ''
    # TODO should probably find the key with value: 'http://www.loc.gov/mods/v3' instead... though without the namespace-prefix
    if xml_doc.namespaces.keys.include? ('xmlns:mods')
      namespace = 'mods|'
    end
    res = Hash.new
    res.merge! extract_agents_from_mods_name_with_namespace(xml_doc, namespace)
    res.merge! extract_agents_from_mods_subject_with_namespace(xml_doc, namespace)
    res.merge! extract_agents_from_mods_publisher_with_namespace(xml_doc, namespace)
  end

  private
  # Extracts the agents from a MODS document at the path 'mods/name'
  # The roles of these names are used for the relations.
  # @param xml_doc The MODS document to extract the agents from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/name'
  def extract_agents_from_mods_name_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'name' (without namespace prefix) with relation from role (or 'Unknown' if not set)
    xml_doc.css("//#{namespace}mods/#{namespace}name").each do |n|
      name = combine_elements(n.css("#{namespace}namePart"))
      # Handle different if it is a corporate -> organization.
      if n.attr('type') == 'corporate'
        agent = find_or_create_agent_organization(name, n.attr('authorityURI'))
      else
        agent = find_or_create_agent_person(name, n.attr('authorityURI'))
      end
      res[agent] = add_to_array(res[agent], n.css("#{namespace}role #{namespace}roleTerm"))
    end
    res
  end
  # Extracts the agents from a MODS document at the path 'mods/subject/name'
  # The roles of these names are used for the relations.
  # @param xml_doc The MODS document to extract the agents from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/subject/name'
  def extract_agents_from_mods_subject_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'subject/name' (without namespace prefix) with relation 'Topic' (ignores role)
    xml_doc.css("//#{namespace}mods/#{namespace}subject/#{namespace}name").each do |n|
      name = combine_elements(n.css("#{namespace}namePart"))
      # Handle different if it is a corporate -> organization.
      if n.attr('type') == 'corporate'
        agent = find_or_create_agent_organization(name, n.attr('authorityURI'))
      else
        agent = find_or_create_agent_person(name, n.attr('authorityURI'))
      end
      res[agent] = add_to_array(res[agent], 'Topic')
    end
    res
  end
  # Extracts the agents from a MODS document at the path 'mods/originInfo/publisher'.
  # They have the publisher relations.
  # @param xml_doc The MODS document to extract the agents from.
  # @param namespace The namespace to use for searching through the document.
  # @return The agents at the path 'mods/originInfo/publisher'
  def extract_agents_from_mods_publisher_with_namespace(xml_doc, namespace)
    res = Hash.new
    # extract from 'subject/name' (without namespace prefix) with relation 'Topic' (ignores role)
    xml_doc.css("//#{namespace}mods/#{namespace}originInfo/#{namespace}publisher").each do |n|
      agent = find_agent_or_create_agent_person(n.text, nil)
      res[agent] = add_to_array(res[agent], 'Publisher')
    end
    res
  end

  # Adds a value to the array.
  # If it is a XML TEXT element, then it is extracted.
  # If it is nil or empty, then it uses the value 'Unknown' instead
  # @param array The array to add the value to.
  # @param value The value to add to the array (String, XML TEXT element or nil)
  # @return The array with the new value. If the array is nil, then it is created.
  def add_to_array(array, value)
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
  def combine_elements(elements)
    res = ''
    elements.reverse.each do |e|
      res += "#{e.text} "
    end
    res.rstrip
  end
end
