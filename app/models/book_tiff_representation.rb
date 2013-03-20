# -*- encoding : utf-8 -*-
class BookTiffRepresentation < Representation
  include ActiveModel::Validations

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  has_many :files, :class_name => 'TiffFile', :property => :is_part_of
  has_many :structmap, :class_name => 'BasicFile', :property => :is_part_of
  belongs_to :book, :property => :is_part_of

  # Whether any intellectual book is represented by this TIFF representation
  def has_book?
    return book
  end

  #def file_type_is_tiff
  #  if :files.size > 0
  #
  #  end
  #end
end