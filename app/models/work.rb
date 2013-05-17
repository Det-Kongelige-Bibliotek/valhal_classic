# -*- encoding : utf-8 -*-
class Work < ActiveFedora::Base
  include Concerns::IntellectualEntity
  include Concerns::Manifestation::Author
  include Concerns::Manifestation::Concerning
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type=>Datastreams::WorkMods

  # TODO define restrictions for these metadata fields.
  delegate_to 'descMetadata',[:shelfLocator, :title, :subTitle, :typeOfResource, :publisher,
                              :originPlace, :languageISO, :languageText, :subjectTopic, :dateIssued,
                              :physicalExtent], :unique=>true
  delegate :work_type, :to => 'descMetadata', :at => [:genre], :unique => true

  # A work can have many representations
  has_many :representations, :class_name => 'ActiveFedora::Base', :property=>:is_representation_of, :inverse_of => :has_representation

  validates :title, :presence => true

  # Determines whether any representations exists.
  def has_rep?
    return representations.any?
  end

  has_solr_fields do |m|
    m.field "search_result_title", method: :title
    m.field "search_result_work_type", method: :work_type
    m.field "shelf_locator", method: :shelfLocator
    m.field "title"
    m.field "sub_title", method: :subTitle
    m.field "type_of_resource", method: :typeOfResource
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
