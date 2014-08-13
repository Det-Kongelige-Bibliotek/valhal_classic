# -*- encoding : utf-8 -*-
class Work < ActiveFedora::Base
  include Concerns::Manifest
  include Concerns::Preservation
  include Concerns::WorkMetadata
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  validates_with WorkValidator

  has_solr_fields do |m|
    m.field "search_result_work_type", method: :workType, :index_as => [:string, :indexed, :stored]
    m.field "title", method: :title
    m.field "sub_title", method: :subTitle
    m.field "type_of_resource", method: :typeOfResource
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

  # For each identifier, create a solr search field with name
  # based on that identifier's displayLabel and value of that identifier's value
  # e.g. {displayLabel: 'aleph', value: '1234'} should create a field
  # {"aleph_si"=>"1234", "aleph_ssm"=>["1234"]}
  def to_solr(solr_doc = {})
    super
    identifier.each do |id|
      if id['displayLabel'] && !id['displayLabel'].empty?
        Solrizer.insert_field(solr_doc, id['displayLabel'], id['value'], :sortable, :displayable)
      end
    end
    solr_doc
  end
  after_save :add_to_instances

end
