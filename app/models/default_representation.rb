class DefaultRepresentation < ActiveFedora::Base
  include Concerns::Representation

  has_metadata name: 'descMetadata', type: ActiveFedora::SimpleDatastream
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  belongs_to :ie, class_name: 'ActiveFedora::Base', :property => :is_representation_of
  has_many :files, class_name: 'ActiveFedora::Base', :property => :is_part_of

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
