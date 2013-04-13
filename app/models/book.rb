# -*- encoding : utf-8 -*-
class Book < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::IntellectualEntity
  include Solr::Indexable

  after_initialize :init

  def init
    @solr_indexer = Solr::DefaultIndexer.new(self)
  end

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => Datastreams::BookMods

  # TODO define restrictions for these metadata fields.
  delegate_to 'descMetadata', [:isbn, :genre, :shelfLocator, :title, :subTitle, :typeOfResource, :publisher,
                               :originPlace, :languageISO, :languageText, :subjectTopic, :dateIssued,
                               :physicalExtent], :unique => true


  # has_many is used as there doesn't seem to be any has_one relation in Active Fedora
  has_many :tei, :class_name => 'BookTeiRepresentation', :property => :is_representation_of
  # A book can be authored by more than one person, and a person can author more than one book.
  has_and_belongs_to_many :authors, :class_name => "Person", :property => :has_author

  has_many :tif, :class_name => 'BookTiffRepresentation', :property => :is_part_of

  validates :title, :presence => true
  validates :isbn, :numericality => true, :allow_blank => true
  validates_with BookValidator

  # Determines whether any TEI representations exists.
  def tei_rep?
    return tei.any?
  end

  # Determines whether any TIFF representations exists.
  def tiff_rep?
    return tif.any?
  end

  # Whether any author for this book has been defined.
  def has_author?
    return authors.any?
  end

  def clear_authors
    authors.clear
  end

  # Delivers the title and subtitle in a format for displaying.
  # Should only include the subtitle, if it has been defined.
  def get_title_for_display
    if subTitle == nil || subTitle.empty?
      return title
    else
      return title + ", " + subTitle
    end
  end

  def authors_names_to_s

    unless authors.nil?
      names = []
      authors.each do |a|
        names << a.name
      end
      names.join(", ")
    end
  end


  def self.solr_fields
    [
        Solr::SolrField.create("search_result_title", method: :title),
        Solr::SolrField.create("search_results_book_authors", index_as: [:string, :indexed, :stored], method: :authors_names_to_s),
        Solr::SolrField.create("isbn", index_as: [:string, :indexed, :stored]),
        Solr::SolrField.create("genre"),
        Solr::SolrField.create("shelf_locator", index_as: [:string, :indexed, :stored], method: :shelfLocator),
        Solr::SolrField.create("title"),
        Solr::SolrField.create("sub_title", method: :subTitle),
        Solr::SolrField.create("type_of_resource", method: :typeOfResource)
    ]
  end
end
