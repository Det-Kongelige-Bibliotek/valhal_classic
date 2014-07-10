# -*- encoding : utf-8 -*-

# Instance with only a single basic_files.
# No underlying structure to keep track of order/relationship between basic_files.
class SingleFileInstance < ActiveFedora::Base
  include Concerns::Instance
  include Concerns::Preservation

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream

  # Overrides the default one by adding the basic_files type in parenthesis.
  def instance_name
    if files.size == 0 || files.last.file_type.blank?
      super
    else
      "#{super} (#{files.last.file_type})"
    end
  end

  # Retrieves a formatted relation to the relations of the manifest.
  # @return The specific metadata for the manifest.
  def get_specific_metadata_for_preservation
    res = ''
    files.each do |file|
      res += '<file>'
      res += "<name>#{file.original_filename}</name>"
      res += "<uuid>#{file.uuid}</uuid>"
      res += '</file>'
    end
    res
  end
end
