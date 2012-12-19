class BookTeiRepresentation < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  belongs_to :file, :class_name => 'BasicFile', :property => :is_part_of

  def file_name
    if file
      self.file.original_filename
    end
  end

  def file_created
    if file
      self.file.created
    end
  end

  def to_solr(solr_doc = {})
    super
    if self.file
      solr_doc[:title_t] = self.file.original_filename
    end
    return solr_doc
  end

end
