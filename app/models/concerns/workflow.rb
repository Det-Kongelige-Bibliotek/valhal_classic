# -*- encoding : utf-8 -*-
module Concerns
  # Add methods and datastream for workflows.
  module Workflow
    extend ActiveSupport::Concern

    included do
      has_metadata :name => 'workflowDatastream', :type => Datastreams::WorkflowDatastream

      # Set variables from the workflow datastream.
      has_attributes :workflow_name, :workflow_error, :workflow_last_update,
                     datastream: 'workflowDatastream', :multiple => false

      # Retrieves the steps.
      # @param *arg The arguments
      # @return The steps.
      def step(*arg)
        self.workflowDatastream.get_step
      end

      # Set the steps.
      # Removes all current alternativeTitle elements, and inserts the given arguments.
      # @param val An array of Hash elements with data for the alternativeTitle.
      def step=(val)
        self.workflowDatastream.remove_step
        val.each do |v|
          unless v['name'].blank?
            self.workflowDatastream.insert_step(v)
          else
            puts "Errors creating step: name => #{v['name']}, methods => #{v['methods']}"
          end
        end
        self.workflow_last_update = DateTime.now.to_s
      end
    end
  end
end
