# -*- encoding : utf-8 -*-
class Entity < ActiveFedora::Base
  include Solr::Indexable
  include Concerns::WorkRelations

  has_metadata :name => 'descMetadata', :type => Datastreams::WorkDescMetadata

  # List of non-multiple key-value pairs
  has_attributes :title, :subTitle, :workType, :shelfLocator,
                 datastream: 'descMetadata', :multiple => false

  # List of multiple key-value pairs
  has_attributes :genre, :identifier, :topic, :physicalDescriptionForm, :physicalDescriptionNote,
                 :languageOfCataloging, :language,
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

  # The fields for the SOLR index.
  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'title', :index_as => [:string, :indexed, :stored]
    m.field 'subTitle', method: :subTitle
    m.field 'search_result_work_type', method: :workType, :index_as => [:string, :indexed, :stored]
    m.field 'language', method: :language, :index_as => [:string, :indexed, :stored]
    m.field 'shelf_locator', method: :shelfLocator, :index_as => [:string, :indexed, :stored]
    m.field 'language_of_cataloging', method: :languageOfCataloging, :index_as => [:string, :indexed, :stored]
    m.field 'search_result_title', method: :get_title_for_display
    m.field 'genre', :index_as => [:string, :indexed, :stored]
    m.field 'identifier', :index_as => [:string, :indexed, :stored]
    m.field 'note', method: :note, :index_as => [:string, :indexed, :stored]
    m.field 'topic', :index_as => [:string, :indexed, :stored]
    m.field 'physical_description_form', method: :physicalDescriptionForm, :index_as => [:string, :indexed, :stored]
    m.field 'physical_description_note', method: :physicalDescriptionNote, :index_as => [:string, :indexed, :stored]

    # Fields from PreservationMetadata
    m.field 'preservation_profile', method: :preservation_profile
    m.field 'preservation_state', method: :preservation_state
    m.field 'preservation_details', method: :preservation_details
  end

end