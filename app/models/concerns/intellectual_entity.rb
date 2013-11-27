# -*- encoding : utf-8 -*-
module Concerns

  module IntellectualEntity
    extend ActiveSupport::Concern

    included do
      include ActiveFedora::Callbacks
      include ActiveFedora::Validations

      has_metadata :name => 'provenanceMetadata', :type => ActiveFedora::SimpleDatastream do |m|
        m.field "uuid", :string
      end

      # Define the uuid as an accessible part of the digitial provenance metadata.
      delegate_to 'provenanceMetadata', [:uuid], :multiple => false

      # Validation criteria of the uuid.
      validates :uuid, :presence => true, :length => {:minimum => 16, :maximum => 64}

      # Automatical creation of a random value in the UUID if it has not been defined at the point of saving.
      before_validation(:on => :create) do
        self.uuid = UUID.new.generate if self.uuid.blank?
      end
    end

  end
end
