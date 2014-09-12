# -*- encoding : utf-8 -*-
module Concerns
  # Module for adding all the descriptive metadata for instance.
  # Both the internal metadata and the relations to the authority metadata.
  module InstanceMetadata
    extend ActiveSupport::Concern

    included do
      include Concerns::WorkInstanceRelations
      has_metadata :name => 'descMetadata', :type => Datastreams::InstanceDescMetadata

      # List of non-multiple key-value pairs
      has_attributes :shelfLocator, :dateCreated, :dateIssued, :tableOfContents, :contentType,
                     datastream: 'descMetadata', :multiple => false

      # List of multiple key-value pairs
      has_attributes :physicalDescriptionForm, :physicalDescriptionNote,
                     :recordOriginInfo, :languageOfCataloging, :dateOther,
                     datastream: 'descMetadata', :multiple => true

      # Extracts the relations, which are valid for instance.
      def get_relations
        res = Hash.new
        relations = METADATA_RELATIONS_CONFIG['instance']
        get_all_relations.each do |k,v|
          if relations.include?(k) && v.empty? == false
            res[k] = v
          end
        end
        res
      end

      # Retrieves the identifier elements.
      # @param *arg Any argument will be ignored.
      # @return The identifier elements.
      def identifier(*arg)
        self.descMetadata.get_identifier
      end

      # Set the identifier elements.
      # Removes all current identifier elements, and inserts the given arguments.
      # @param vals An array of Hash elements with data for the identifiers.
      def identifier=(vals)
        self.descMetadata.remove_identifier
        vals.each do |v|
          self.descMetadata.insert_identifier(v) unless v['value'].blank?
        end
      end

      # Retrieves the note elements.
      # @param *arg Any argument will be ignored.
      # @return The note elements.
      def note(*arg)
        self.descMetadata.get_note
      end

      # Set the note elements.
      # Removes all current note elements, and inserts the given arguments.
      # @param vals An array of Hash elements with data for the notes.
      def note=(vals)
        self.descMetadata.remove_note
        vals.each do |v|
          self.descMetadata.insert_note(v) unless v['value'].blank?
        end
      end

    end

  end
end