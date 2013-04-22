# -*- encoding : utf-8 -*-
class SingleFileRepresentation < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  # Whether any intellectual work is represented by the file of this representation
  def has_work?
    work
  end

  # retrieves the file of the representation
  def file
    if files.empty?
      return nil
    end
   files.all.last
  end


end
