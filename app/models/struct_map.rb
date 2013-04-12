# -*- encoding : utf-8 -*-
class StructMap < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::Representation

  has_metadata :name=> 'techMetadata', :type=>Datastreams::MetsStructMap

  delegate_to 'techMetadata',[:div, :order, :fptr, :file_id]

end
