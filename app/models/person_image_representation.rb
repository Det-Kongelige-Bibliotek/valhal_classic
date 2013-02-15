# -*- encoding : utf-8 -*-
class PersonImageRepresentation < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  has_many :person_image_files, :class_name => 'BasicFile', :property => :is_part_of
  # Relationship to be abstract Person
  belongs_to :person, :property => :is_representation_of

end