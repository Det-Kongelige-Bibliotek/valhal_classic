# -*- encoding : utf-8 -*-
class BasicFile < ActiveFedora::Base
  include Concerns::GenericFile

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
end
