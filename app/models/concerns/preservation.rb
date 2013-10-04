# -*- encoding : utf-8 -*-
module Concerns
  # The preservation definition which are to be used by all elements.
  # Adds the preservation metadata datastream, and sets up default values.
  module Preservation
    extend ActiveSupport::Concern

    included do
      include ActiveFedora::Callbacks

      has_metadata :name => 'preservationMetadata', :type => Datastreams::PreservationDatastream
      delegate_to 'preservationMetadata', [:preservation_profile, :preservation_state, :preservation_details, :preservation_date], :unique => true

      before_validation(:on => :create) do
        self.preservation_profile = "Undefined" if preservation_profile.blank?
        self.preservation_state = "None" if preservation_state.blank?
        self.preservation_details = "N/A" if preservation_details.blank?
        self.preservation_date = DateTime.now.to_s if preservation_date.blank?
      end
    end
  end
end
