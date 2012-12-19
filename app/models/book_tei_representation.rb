class BookTeiRepresentation < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  belongs_to :file, :class_name => 'BasicFile', :property=> :is_part_of

  def file_name
    self.file.original_filename
  end

  def file_created
    self.file.created
  end

end
