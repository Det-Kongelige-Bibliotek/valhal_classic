module InstanceHelper

  # Iterate over the agent relations finding the referenced AMU and adding the required relationship to the instance for
  # that AMU.
  # @param [Hash] agent_relations
  # @param [Work] work
  def add_agents(agent_relations, instance)

    agent_relations.each do |agent_relation_hash|
      agent_relation_hash.each do |agent_relation|
        agent = AuthorityMetadataUnit.find(agent_relation[1]['agentID'])
        if agent_relation[1]['relationshipType'].eql? 'hasTopic'
          instance.hasTopic << agent
        elsif agent_relation[1]['relationshipType'].eql? 'hasOrigin'
          instance.hasOrigin << agent
        elsif agent_relation[1]['relationshipType'].eql? 'hasContributor'
          instance.hasContributor << agent
        elsif agent_relation[1]['relationshipType'].eql? 'hasOwner'
          instance.hasOwner << agent
        elsif agent_relation[1]['relationshipType'].eql? 'hasPatron'
          instance.hasPatron << agent
        elsif agent_relation[1]['relationshipType'].eql? 'hasPrinter'
          instance.hasPrinter << agent
        elsif agent_relation[1]['relationshipType'].eql? 'hasPublisher'
          instance.hasPublisher << agent
        elsif agent_relation[1]['relationshipType'].eql? 'hasScribe'
          instance.hasScribe << agent
        elsif agent_relation[1]['relationshipType'].eql? 'hasDigitizer'
          instance.hasDigitizer << agent
        end
      end
    end
  end
end