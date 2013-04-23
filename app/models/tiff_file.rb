# -*- encoding : utf-8 -*-
require 'RMagick'

class TiffFile < ActiveFedora::Base
  include Concerns::BasicFile
  include Concerns::IntellectualEntity

  def add_file(file)
    #puts file.inspect
    valid = super
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

  def has_thumbnail?
    if self.respond_to? :thumbnail
      return self.thumbnail ? true : false
    end
    return false
  end
end