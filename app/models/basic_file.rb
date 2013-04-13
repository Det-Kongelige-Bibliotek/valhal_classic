# -*- encoding : utf-8 -*-
class BasicFile < ActiveFedora::Base
  include Concerns::IntellectualEntity
  include Concerns::BasicFile

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
end
