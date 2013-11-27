# -*- encoding : utf-8 -*-
require 'RMagick'

class TiffFile < ActiveFedora::Base
  include Concerns::BasicFile

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  def add_file(file, skip_file_characterisation)
    unless file.content_type.include?('image/tif')
      return false
    end

    valid = super(file, skip_file_characterisation)
    if(valid)
      self.save!
      self.create_thumbnail(file)
    end
    valid
  end

  def create_thumbnail(file)
    thumb = Magick::Image.read(file.tempfile.path)[0]
    thumb.format = "PNG"
    thumb.resize_to_fill!(100)

    self.add_file_datastream(thumb.to_blob, :label => file.original_filename.to_s + "_thumbnail.png", :mimeType => "image/png", :dsid => 'thumbnail')
    self.save!
  end
end
