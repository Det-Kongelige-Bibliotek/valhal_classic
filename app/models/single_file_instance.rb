# -*- encoding : utf-8 -*-

# Instance with only a single basic_files.
# No underlying structure to keep track of order/relationship between basic_files.
class SingleFileInstance < ActiveFedora::Base
  include Concerns::Instance
  include Concerns::Preservation
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  # Given a Ruby File object
  # create SingleFileInstance
  # with BasicFile containing
  # this file
  # @param File
  # @return SingleFileInstance
  def self.new_from_file(file, skip_fits=true)
    inst = self.new
    bf = BasicFile.new
    bf.add_file(file, skip_fits)
    inst.files << bf
    inst.save
    inst
  end

  # Overrides the default one by adding the basic_files type in parenthesis.
  def instance_name
    if files.size == 0 || files.last.file_type.blank?
      super
    else
      "#{super} (#{files.last.file_type})"
    end
  end

  # Accessor method to get the only
  # connected file
  # @return BasicFile
  def file
    files.first
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

  # The fields for the SOLR index.
  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'search_result_title', method: :get_work_title
  end

  #Get the title of the work this single file instance belongs to
  #return String title of the work
  def get_work_title
    if self.ie.nil?
      ""
    else
      self.ie.title
    end
  end
end
