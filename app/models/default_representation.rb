class DefaultRepresentation < ActiveFedora::Base
  include Concerns::Representation

  has_metadata name: 'descMetadata', type: ActiveFedora::SimpleDatastream
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

end
