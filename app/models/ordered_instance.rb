# -*- encoding : utf-8 -*-
class OrderedInstance < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::Instance
  include Concerns::Preservation

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'techMetadata',   :type => Datastreams::MetsStructMap

  has_attributes :div, :order, :fptr, :file_id, datasteam: 'techMetadata', :multiple => false
end
