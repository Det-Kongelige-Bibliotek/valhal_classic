# -*- encoding : utf-8 -*-
class OrderedInstance < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::Instance
  include Concerns::Preservation
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'techMetadata',   :type => Datastreams::MetsStructMap

  has_attributes :div, :order, :fptr, :file_id, datastream: 'techMetadata', :multiple => false

  # The fields for the SOLR index.
  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'search_result_title', method: :get_work_title
  end

  #Get the title of the work this ordered instance belongs to
  #return String title of the work
  def get_work_title
    if self.ie.nil?
      ""
    else
      self.ie.title
    end
  end

  # get an array of the original
  # filenames of all files
  # @return Array of Strings
  def original_filenames
    files.map{|f| f.original_filename }
  end

  # Check if instance already contains
  # a file with original filename <filename>
  # @param String
  # @return Boolean
  def has_file?(filename)
    original_filenames.include? filename
  end

  # Retrieve a file based on its original filename
  # else nil
  # @return BasicFile | nil
  def find_file(filename)
    files.each do |f|
      return f if f.original_filename = filename
    end
    nil
  end
end
