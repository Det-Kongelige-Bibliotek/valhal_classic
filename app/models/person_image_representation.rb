# -*- encoding : utf-8 -*-
class PersonImageRepresentation < Representation
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  #validate :is_image_file?
  
  has_many :person_image_files, :class_name => 'BasicFile', :property => :is_part_of
  # Relationship to be abstract Person
  belongs_to :person, :property => :is_representation_of

  def is_image_file?
    logger.debug "in is_image_file..."
    self.person_image_files.each do |f|
      logger.debug "f.mime_type.to_s = " + f.mime_type.to_s
      unless f.mime_type.eql? 'image/tiff'
        unless self.person.nil?
          self.person.errors.add(:person_image_files, 'File must be an image file')
          return false
        end
      end
    end
    unless self.person.nil?
      logger.debug "self.person.errors.size = " + self.person.errors.size.to_s
    end
  end

end