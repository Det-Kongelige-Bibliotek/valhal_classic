# -*- encoding : utf-8 -*-
module Concerns
  module Manifestation
    # handles the is_concerned_by relationship from the agent to the different manifestations
    module Concerning
      extend ActiveSupport::Concern

      included do
        #A manifestation can concern an agent, e.g. as a AuthorDescription, biography, etc.
        has_and_belongs_to_many :agents_concerned, :class_name => 'ActiveFedora::Base', :property => :concerning, :inverse_of => :is_concerned_by
      end

      # Whether any agent is concerned by this manifestation.
      def has_concerned_agent?
        agents_concerned.any?
      end

      # clears the agents_concerned list.
      # return false if there is no concerned agents in this manifestation,
      # else true
      def clear_concerned_agents
        unless self.agents_concerned.empty?
          self.agents_concerned_ids = []
          true
        end
      end

      def clear_topics
        unless self.hasTopic.empty?
          self.hasTopic = []
          true
        end
      end
    end
  end
end