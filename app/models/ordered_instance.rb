# -*- encoding : utf-8 -*-
class OrderedInstance < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include ActiveModel::Validations
  include Concerns::Instance
  include Concerns::Preservation
  include Solr::Indexable
  include Hydra::AccessControls::Permissions

  has_metadata :name => 'techMetadata',   :type => Datastreams::MetsStructMap

  has_attributes :div, :order, :fptr, :file_id, datastream: 'techMetadata', :multiple => false

  # The fields for the SOLR index.
  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'search_result_title', method: :get_work_title
  end

  #Get the title of the work this ordered instance belongs to
  #return String title of the work
  def get_work_title
    if self.ie.nil?
      ""
    else
      self.ie.title
    end
  end
end
