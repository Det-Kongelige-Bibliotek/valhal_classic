# -*- encoding : utf-8 -*-

class TiffFile < ActiveFedora::Base
  include Concerns::GenericFile

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  def add_file(file, skip_file_characterisation)
    unless file.content_type.include?('image/tif')
      return false
    end

    valid = super(file, skip_file_characterisation)
    if(valid)
      self.save!
    end
    valid
  end

end
