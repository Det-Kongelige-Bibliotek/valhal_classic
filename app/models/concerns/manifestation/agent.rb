# -*- encoding : utf-8 -*-
module Concerns
  module Manifestation
    # handles the agent relationship from the person to the different manifestations
    module Agent
      extend ActiveSupport::Concern

      included do
        # A manifestation can be agented by more than one person, and a person can agent more than one book.
        has_and_belongs_to_many :agents, :class_name => 'ActiveFedora::Base', :property => :has_agent, :inverse_of => :is_agent_of
      end

      # Whether any author for this book has been defined.
      def has_author?
        return agents.any?
      end

      # Whether any author for this book has been defined.
      def has_agent?
        return agents.any?
      end

      # clears the agent list.
      # return false if there is no agents in this manifestation,
      # else true
      def clear_agents
        unless self.agents.empty?
          self.agent_ids = []
          true
        end
      end
    end
  end
end