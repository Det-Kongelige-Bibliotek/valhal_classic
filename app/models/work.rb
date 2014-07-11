# -*- encoding : utf-8 -*-
class Work < ActiveFedora::Base
  include Concerns::Manifest
  include Concerns::Manifestation::Author
  include Concerns::Manifestation::Concerning
  include Concerns::Preservation
  include Concerns::WorkMetadata
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  validates :title, :presence => true
  validates_with WorkValidator

  has_solr_fields do |m|
    m.field "search_result_work_type", method: :workType, :index_as => [:string, :indexed, :stored]
    m.field "title", method: :title
    m.field "sub_title", method: :subTitle
    m.field "type_of_resource", method: :typeOfResource
    m.field "sysNum", method: :sysNum, :index_as => [:string, :indexed, :stored]
    m.field "search_result_title", method: :get_title_for_display
    m.field "work_type", method: :workType
    m.field 'preservation_profile', method: :preservation_profile
    m.field 'preservation_state', method: :preservation_state
    m.field 'preservation_details', method: :preservation_details
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

  after_save :add_ie_to_instances
  private
  def add_ie_to_instances
    add_ie_to_instances instances
  end

  def add_ie_to_instances(ins_array)
    ins_array.each do |ins|
      if ins.ie.nil?
        ins.ie = self
        ins.save
      end
    end unless ins_array.nil?
  end

end
