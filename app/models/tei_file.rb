# -*- encoding : utf-8 -*-
class TeiFile < ActiveFedora::Base
  include Concerns::BasicFile

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  has_metadata :name => 'techMetadata2', :type => ActiveFedora::SimpleDatastream do |m|
    m.field 'tei_version', :string
  end

  has_attributes :tei_version, datastream: 'techMetadata2', :multiple => false

  # Overrides the super method, by validating that it at least is an XML basic_files.
  # @param file The TEI file to add as content.
  def add_file(file, skip_file_characterisation)
    unless file.content_type == 'text/xml'
      return false
    end
    super(file, skip_file_characterisation)
  end

  # @return The type tei of file. If unknown, then just use the super-method for returning the mime-type.
  def file_type
    if tei_version.blank?
      super
    else
      'TEI version: ' + tei_version
    end
  end
end
