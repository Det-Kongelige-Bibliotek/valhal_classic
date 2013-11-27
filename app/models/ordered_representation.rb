# -*- encoding : utf-8 -*-
class OrderedRepresentation < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::IntellectualEntity
  include Concerns::Representation
  include Concerns::Preservation

  has_metadata :name => 'descMetadata',   :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'techMetadata',   :type => Datastreams::MetsStructMap

  has_attributes :div, :order, :fptr, :file_id, datasteam: 'techMetadata', :multiple => false
end
