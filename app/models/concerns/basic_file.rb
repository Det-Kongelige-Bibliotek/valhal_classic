# -*- encoding : utf-8 -*-
module Concerns

  # BasicFile contains tha basic functionality for a class meant to be a kind af file
  # in order for this module to work a class must inherit from ActiveFedora::Base
  # it is meant to be included in the file classes
  # Example:
  # Class TiffFile < ActiveFedora::Base
  # include Concerns::BasicFile
  module BasicFile
    extend ActiveSupport::Concern
    include Hydra::Models::FileAsset

    included do
      include Concerns::IntellectualEntity
      include Concerns::Preservation
      # a ActiveFedora::SimpleDatastream for the techMetadata
      # TODO find out if we need to make our own Datastream for techMetadata
      has_metadata :name => 'techMetadata', :type => ActiveFedora::SimpleDatastream do |m|
        m.field "file_checksum", :string
        m.field "original_filename", :string
        m.field "mime_type", :string
        m.field "file_size", :integer
        m.field "last_modified", :string
        m.field "created", :string
        m.field "last_accessed", :string
      end

      delegate_to 'techMetadata', [:last_modified, :created, :last_accessed, :original_filename, :mime_type], :unique => true
      delegate_to 'descMetadata', [:description], :unique => true
      # TODO have more than one checksum (both MD5 and SHA), and specify their checksum algorithm.
      delegate :checksum, :to => 'techMetadata', :at => [:file_checksum], :unique => true
      delegate :size, :to => 'techMetadata', :at => [:file_size], :unique => true
    end

    # adds a content datastream to the object and generate techMetadata for the file
    # file must have the following methods [size, content_type, original_filename, tempfile]
    # return true if successful, else false
    def add_file(file)
      valid_file = check_file?(file)
      if (valid_file)
        self.add_file_datastream(file.tempfile, :label => file.original_filename, :mimeType => file.content_type, :dsid => 'content')
        set_file_timestamps(file.tempfile)
        self.checksum = generate_checksum(file.tempfile)
        self.original_filename = file.original_filename
        self.mime_type = file.content_type
        self.size = file.size
      end
      valid_file
    end

    # @return the type of file. Default the mime-type
    def file_type
      mime_type
    end

    # @return Whether the file has a thumbnail.
    def has_thumbnail?
      if self.respond_to? :thumbnail
        return self.thumbnail ? true : false
      end
      return false
    end

    private
    def generate_checksum(file)
      Digest::MD5.file(file).hexdigest
    end

    # TODO describe the different timestamps.
    def set_file_timestamps(file)
      self.created = file.ctime.to_s
      self.last_accessed = file.atime.to_s
      self.last_modified = file.mtime.to_s
    end

    #returns true if file has all the methods that is needed by #add_file else false is returned
    def check_file?(file)
      file_methods = [:size, :tempfile, :content_type, :original_filename,]
      file_methods.each do |method_name|
        unless file.respond_to?(method_name)
          logger.error "file doesn't support #{method_name} method"
          return false
        end
      end
      true
    end
  end
end
