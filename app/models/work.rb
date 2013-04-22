# -*- encoding : utf-8 -*-
class Work < ActiveFedora::Base
  include Concerns::IntellectualEntity
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name=>'descMetadata', :type=>Datastreams::WorkMods

  # TODO define restrictions for these metadata fields.
  delegate_to 'descMetadata',[:shelfLocator, :title, :subTitle, :typeOfResource, :publisher,
                              :originPlace, :languageISO, :languageText, :subjectTopic, :dateIssued,
                              :physicalExtent], :unique=>true
  delegate :work_type, :to => 'descMetadata', :at => [:genre], :unique => true

  # A book can be authored by more than one person, and a person can author more than one book.
  has_and_belongs_to_many :authors, :class_name=>"Person", :property => :has_author

  # A work can have many representations
  has_many :representations, :class_name => 'ActiveFedora::Base', :property=>:is_representation_of

  validates :title, :presence => true
  validates :work_type, :presence => true

  # Determines whether any representations exists.
  def has_rep?
    return representations.any?
  end

  # Whether any author for this book has been defined.
  def has_author?
    return authors.any?
  end

  has_solr_fields do |m|
    m.field "search_result_title", method: :title
    m.field "search_result_work_type", method: :work_type
    m.field "shelf_locator", method: :shelfLocator
    m.field "title"
    m.field "sub_title", method: :subTitle
    m.field "type_of_resource", method: :typeOfResource
  end

  after_save :add_ie_to_reps
  private
  def add_ie_to_reps
    add_ie_to_rep representations
  end

  def add_ie_to_rep(rep_array)
    rep_array.each do |rep|
      if rep.ie.nil?
        rep.ie = self
        rep.save
      end
    end unless rep_array.nil?
  end

end
