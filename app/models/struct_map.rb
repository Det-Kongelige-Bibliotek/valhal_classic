# -*- encoding : utf-8 -*-
class StructMap < IntellectualEntity
  include ActiveModel::Validations

  has_metadata :name=> 'techMetadata', :type=>Datastreams::MetsStructMap

  delegate_to 'techMetadata',[:div, :order, :fptr, :file_id]
end
