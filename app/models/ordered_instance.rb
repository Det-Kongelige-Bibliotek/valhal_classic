# -*- encoding : utf-8 -*-
class OrderedInstance < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::Instance
  include Concerns::Preservation
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'techMetadata',   :type => Datastreams::MetsStructMap

  has_attributes :div, :order, :fptr, :file_id, datastream: 'techMetadata', :multiple => false

  # The fields for the SOLR index.
  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'search_result_title', method: :get_work_title
  end

  def get_work_title
    self.ie.title
  end
end
