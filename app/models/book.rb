# -*- encoding : utf-8 -*-
class Book < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::Manifest
  include Concerns::Manifestation::Author
  include Concerns::Manifestation::Concerning
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => Datastreams::BookMods

  # TODO define restrictions for these metadata fields.
  delegate_to 'descMetadata', [:isbn, :genre, :shelfLocator, :title, :subTitle, :typeOfResource, :publisher,
                               :originPlace, :languageISO, :languageText, :subjectTopic, :dateIssued,
                               :physicalExtent], :unique => true

  validates :title, :presence => true
  validates :isbn, :numericality => true, :allow_blank => true
  validates_with BookValidator
  after_save :add_ie_to_reps

  # Delivers the title and subtitle in a format for displaying.
  # Should only include the subtitle, if it has been defined.
  def get_title_for_display
    if subTitle == nil || subTitle.empty?
      return title
    else
      return title + ', ' + subTitle
    end
  end

  def authors_names_to_s

    unless authors.nil?
      names = []
      authors.each do |a|
        names << a.name
      end
      names.join(', ')
    end
  end

  has_solr_fields do |m|
    m.field 'search_result_title', method: :title
    m.field 'search_results_book_authors', index_as: [:string, :indexed, :stored], method: :authors_names_to_s
    m.field 'isbn', index_as: [:string, :indexed, :stored]
    m.field 'genre'
    m.field 'shelf_locator', index_as: [:string, :indexed, :stored], method: :shelfLocator
    m.field 'title'
    m.field 'sub_title', method: :subTitle
    m.field 'type_of_resource', method: :typeOfResource
  end
end
