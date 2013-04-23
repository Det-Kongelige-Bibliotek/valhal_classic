# -*- encoding : utf-8 -*-

# Representation with only a single file.
# No underlying structure to keep track of order/relationship between files.
class SingleFileRepresentation < ActiveFedora::Base
  include Concerns::Representation
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  # Whether any intellectual work is represented by the file of this representation
  def has_work?
    work
  end

  # retrieves the file of the representation
  # returns nil if no files
  def file
    if files.empty?
      return nil
    end
   files.all.last
  end
end
