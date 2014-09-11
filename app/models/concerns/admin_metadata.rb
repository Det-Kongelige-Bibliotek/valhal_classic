# -*- encoding : utf-8 -*-
module Concerns
  # Handles the administrative metadata.
  module AdminMetadata
    extend ActiveSupport::Concern

    included do
      has_metadata :name => 'adminMetadata', :type => Datastreams::AdminDatastream

      # List of non-multiple key-value pairs
      has_attributes :activity, :workflow_status, :embargo, :embargo_date, :embargo_condition, :access_condition,
                     :copyright, :material_type, :availability,
                     datastream: 'adminMetadata', :multiple => false

      # List of multiple key-value pairs
      has_attributes :collection, datastream: 'adminMetadata', :multiple => false

    end
  end
end
