# -*- encoding : utf-8 -*-

# Representation with only a single file.
# No underlying structure to keep track of order/relationship between files.
class SingleFileRepresentation < ActiveFedora::Base
  include Concerns::Representation

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream

  # Overrides the default one by adding the file type in parenthesis.
  def representation_name
    if files.size == 0 || files.last.file_type.blank?
      super
    else
      "#{super} (#{files.last.file_type})"
    end
  end
end
