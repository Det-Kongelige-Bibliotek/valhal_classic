# -*- encoding : utf-8 -*-
class SingleFileRepresentation < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  has_many :files, :class_name => 'BasicFile', :property => :is_part_of
  belongs_to :work, :class_name=>'Work', :property => :is_representation_of

  # Whether any intellectual work is represented by the file of this representation
  def has_work?
    return work
  end

  # retrieves the file of the representation
  def get_file
    if files.empty?
      return nil
    end
    return files.all.last
  end
end
