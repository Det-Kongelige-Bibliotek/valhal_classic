# -*- encoding : utf-8 -*-
module Concerns
  # Module for adding the all the descriptive metadata for Work.
  # Both the internal metadata and the relations to the authority metadata.
  module WorkMetadata
    extend ActiveSupport::Concern

    included do
      include Concerns::WorkRelations
      has_metadata :name => 'descMetadata', :type => Datastreams::WorkDescMetadata

      # List of non-multiple key-value pairs
      has_attributes :title, :subTitle, :workType, :carthographicsScale, :carthographicsCoordinates, :dateCreated,
                     :tableOfContents, :recordOriginInfo, :typeOfResource, :typeOfResourceLabel,
                     datastream: 'descMetadata', :multiple => false

      # List of multiple key-value pairs
      has_attributes :dateOther, :genre, :languageOfCataloging, :topic,
                     datastream: 'descMetadata', :multiple => true

      # Retrieves the alternative titles.
      # @param *arg The arguments
      # @return The alternative titles.
      def alternativeTitle(*arg)
        self.descMetadata.get_alternative_title
      end

      # Set the alternative titles.
      # Removes all current alternativeTitle elements, and inserts the given arguments.
      # @param val An array of Hash elements with data for the alternativeTitle.
      def alternativeTitle=(val)
        self.descMetadata.remove_alternative_title
        val.each do |v|
          self.descMetadata.insert_alternative_title(v) unless v['title'].blank? || v['type'].blank?
        end
      end

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

      # Retrieves the language elements.
      # @param *arg The arguments
      # @return The language elements.
      def language(*arg)
        self.descMetadata.get_language
      end

      # Set the language elements.
      # Removes all current language elements, and inserts the given arguments.
      # @param val An array of Hash elements with data for the language.
      def language=(val)
        self.descMetadata.remove_language
        val.each do |v|
          self.descMetadata.insert_language(v) unless v['value'].blank?
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