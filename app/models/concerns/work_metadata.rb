# -*- encoding : utf-8 -*-
module Concerns
  # Module for adding all the descriptive metadata for Work.
  # Both the internal metadata and the relations to the authority metadata.
  module WorkMetadata
    extend ActiveSupport::Concern

    included do
      include Concerns::WorkInstanceRelations
      has_metadata :name => 'descMetadata', :type => Datastreams::WorkDescMetadata

      # List of non-multiple key-value pairs
      has_attributes :title, :subTitle, :workType, :cartographicsScale, :cartographicsCoordinates, :dateCreated,
                     :tableOfContents, :typeOfResource, :typeOfResourceLabel, :recordOriginInfo,
                     datastream: 'descMetadata', :multiple => false

      # List of multiple key-value pairs
      has_attributes :dateOther, :genre, :languageOfCataloging, :topic,
                     datastream: 'descMetadata', :multiple => true


      # Extracts the relations, which are valid for work.
      def get_relations
        res = Hash.new
        relations = METADATA_RELATIONS_CONFIG['work']
        get_all_relations.each do |k,v|
          if relations.include?(k) && v.empty? == false
            res[k] = v
          end
        end
        res
      end

      # Retrieves the alternative titles.
      # @param *arg Any argument will be ignored.
      # @return The alternative titles.
      def alternativeTitle(*arg)
        self.descMetadata.get_alternative_title
      end

      # Set the alternative titles.
      # Removes all current alternativeTitle elements, and inserts the given arguments.
      # @param vals An array of Hash elements with data for the alternativeTitle.
      def alternativeTitle=(vals)
        self.descMetadata.remove_alternative_title
        vals.each do |v|
          self.descMetadata.insert_alternative_title(v) unless v['title'].blank? || v['type'].blank?
        end
      end

      # Retrieves the identifier elements.
      # @param *arg Any argument will be ignored.
      # @return The identifier elements.
      def identifier(*arg)
        self.descMetadata.get_identifier
      end

      # Set the identifier elements.
      # Removes all current identifier elements, and inserts the given arguments.
      # Note that identifiers will only be indexed when a displayLabel will be given
      # See Work.to_solr for details
      # @param vals An array of Hash elements with data for the identifiers.
      def identifier=(vals)
        self.descMetadata.remove_identifier
        vals.each do |v|
          self.descMetadata.insert_identifier(v) unless v['value'].blank?
        end
      end

      # Retrieves the language elements.
      # @param *arg Any argument will be ignored.
      # @return The language elements.
      def language(*arg)
        self.descMetadata.get_language
      end

      # Set the language elements.
      # Removes all current language elements, and inserts the given arguments.
      # @param vals An array of Hash elements with data for the language.
      def language=(vals)
        self.descMetadata.remove_language
        vals.each do |v|
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