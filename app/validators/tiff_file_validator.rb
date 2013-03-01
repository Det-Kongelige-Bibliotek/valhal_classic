# -*- encoding : utf-8 -*-
class TiffFileValidator < ActiveModel::Validator
  def validate(record)
    record.files.each do |f|
      puts f.mime_type.to_s
      unless f.mime_type.eql? 'image/tiff'
        record.errors[:files] << 'Image file must be a tiff file'
      end
      puts record.errors.size
    end
  end
end

module ActiveModel::Validations::HelperMethods
  def validates_tiff_file_type(*attr_names)
    validates_with TiffFileValidator, _merge_attributes(attr_names)
  end
end