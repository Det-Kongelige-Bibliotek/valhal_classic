# -*- encoding : utf-8 -*-
class Work < ActiveFedora::Base
  include Concerns::Manifest
  include Concerns::Manifestation::Author
  include Concerns::Manifestation::Concerning
  include Concerns::Preservation
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type=>Datastreams::WorkMods

  # TODO define restrictions for these metadata fields.
  has_attributes :shelfLocator, :title, :subTitle, :typeOfResource, :publisher, :originPlace, :languageISO,
                 :languageText, :subjectTopic, :dateIssued, :physicalExtent, :sysNum,
                 datastream: 'descMetadata', :multiple => false
  has_attributes :work_type, datastream: 'descMetadata', :at => [:genre], :multiple => false

  validates :title, :presence => true
  validates_with WorkValidator

  has_solr_fields do |m|
    m.field "search_result_title", method: :title
    m.field "search_result_work_type", method: :work_type, :index_as => [:string, :indexed, :stored]
    m.field "shelf_locator", method: :shelfLocator
    m.field "title"
    m.field "sub_title", method: :subTitle
    m.field "type_of_resource", method: :typeOfResource
    m.field "sysNum", method: :sysNum, :index_as => [:string, :indexed, :stored]
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

  has_solr_fields do |m|
    m.field "search_result_title", method: :get_title_for_display
    m.field "work_type", method: :work_type
    m.field 'preservation_profile', method: :preservation_profile
    m.field 'preservation_state', method: :preservation_state
    m.field 'preservation_details', method: :preservation_details
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
