class OrderedRepresentation < ActiveFedora::Base
  include Concerns::Representation

  has_metadata name: 'descMetadata', type: ActiveFedora::SimpleDatastream
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  has_many :structmap, :class_name => 'StructMap', :property => :is_part_of

end
