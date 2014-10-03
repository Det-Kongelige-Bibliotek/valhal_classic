# -*- encoding : utf-8 -*-
class OrderedInstance < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::Instance
  include Concerns::Preservation
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'techMetadata',   :type => Datastreams::MetsStructMap

  has_attributes :div, :order, :fptr, :file_id, datastream: 'techMetadata', :multiple => false
  has_attributes :contentType, datastream: 'descMetadata', multiple: false

  validates :collection, :presence => true

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


  # Overrides the default one by adding the basic_files type in parenthesis.
  def instance_name
    if files.size == 0
      "#{super} (no content)"
    elsif contentType.present?
      "#{super} (#{contentType} - #{files.size} files)"
    else
      "#{super} - #{files.size} file)"
    end
  end
end
