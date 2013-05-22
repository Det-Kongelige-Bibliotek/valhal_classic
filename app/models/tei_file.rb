# -*- encoding : utf-8 -*-
class TeiFile < ActiveFedora::Base
  include Concerns::BasicFile
  include Concerns::IntellectualEntity

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  has_metadata :name => 'techMetadata2', :type => ActiveFedora::SimpleDatastream do |m|
    m.field 'tei_version', :string
  end

  delegate_to 'techMetadata2', [:tei_version], :unique => true

  # Overrides the super method, by validating that it at least is an XML file.
  # @param file The TEI file to add as content.
  def add_file(file)
    unless file.content_type == 'text/xml'
      return false
    end
    super(file)
  end

  # @return The
  def file_type
    if tei_version.blank?
      'TEI file'
    else
      'TEI ' + tei_version
    end
  end
end
