# -*- encoding : utf-8 -*-
module Concerns
  # Module for adding the all the descriptive metadata for instance.
  # Both the internal metadata and the relations to the authority metadata.
  module InstanceMetadata
    extend ActiveSupport::Concern

    included do
      include Concerns::InstanceRelations
      has_metadata :name => 'descMetadata', :type => Datastreams::InstanceDescMetadata

      # List of non-multiple key-value pairs
      has_attributes :shelfLocator, :dateCreated, :dateIssued, :recordOriginInfo, :tableOfContents,
                     datastream: 'descMetadata', :multiple => false

      # List of multiple key-value pairs
      has_attributes :physicalDescriptionForm, :physicalDescriptionNote,
                     :languageOfCataloging, :dateOther,
                     datastream: 'descMetadata', :multiple => true

      # Retrieves the note elements.
      # @param *arg The arguments
      # @return The note elements.
      def identifier(*arg)
        self.descMetadata.get_identifier
      end

      # Set the note elements.
      # Removes all current note elements, and inserts the given arguments.
      # @param val An array of Hash elements with data for the notes.
      def identifier=(val)
        self.descMetadata.remove_identifier
        val.each do |v|
          self.descMetadata.insert_identifier(v) unless v['value'].blank?
        end
      end

      # Retrieves the note elements.
      # @param *arg The arguments
      # @return The note elements.
      def note(*arg)
        self.descMetadata.get_note
      end

      # Set the note elements.
      # Removes all current note elements, and inserts the given arguments.
      # @param val An array of Hash elements with data for the notes.
      def note=(val)
        self.descMetadata.remove_note
        val.each do |v|
          self.descMetadata.insert_note(v) unless v['value'].blank?
        end
      end

    end

  end
end