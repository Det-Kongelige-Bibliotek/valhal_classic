# -*- encoding : utf-8 -*-

# Finds the different
module AMUFinderService

  # Finds or creates a AuthorityMetadataUnit with type agent/person.
  # @param name The value of the agent/person
  # @return The agent/person with the given name.
  def find_or_create_agent_person(name)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/person\" && amu_value_ssi:\"#{name}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'agent/person', :value => name)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Finds or creates a AuthorityMetadataUnit with type agent/organization.
  # @param name The value of the agent/organization
  # @return The agent/organization with the given name.
  def find_or_create_agent_organization(name)
    search = AuthorityMetadataUnit.find_with_conditions("amu_type_ssi:\"agent/organization\" && amu_value_ssi:\"#{name}\"").first
    if search.nil?
      AuthorityMetadataUnit.create(:type=>'agent/organization', :value => name)
    else
      AuthorityMetadataUnit.find(search['id'])
    end
  end

  # Extract the agents and their relations from a MODS record,
  # The agents are either agent/organization or agent/person depending on type attribute on the name element.
  # Does not create a new agent, if a similar one already exists with the same name. Then just use existing one.
  # TODO: Only extracts from the 'name' node.
  # @param mods The MODS to extract the agent from.
  # @return A hash between the agents and their relation.
  def find_agents_with_relation_from_mods(mods)
    xml_doc = Nokogiri::XML(mods)

    # extract from 'name'
    node_set = xml_doc.css('name')

    res = Hash.new
    node_set.each do |n|
      name = n.css('namePart').first.text
      # Handle different if it is a corporate -> organization.
      if n.attr('type') == 'corporate'
        agent = find_or_create_agent_organization(name)
      else
        agent = find_or_create_agent_person(name)
      end
      res[agent] = n.css('role/roleTerm').first.text
    end

    res
  end
end
