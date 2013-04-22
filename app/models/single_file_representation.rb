# -*- encoding : utf-8 -*-
class SingleFileRepresentation < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream
  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  has_many :files, :class_name => 'ActiveFedora::Base', :property => :is_part_of
  belongs_to :ie, :class_name=>'ActiveFedora::Base', :property => :is_representation_of

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

  after_save :add_representation_to_files

  private
  def add_representation_to_files
    files.each do |file|
      if file.container.nil?
        file.container = self
        file.save
      end
    end unless files.nil?
  end
end
