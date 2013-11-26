# -*- encoding : utf-8 -*-
module Concerns

  # BasicFile contains tha basic functionality for a class meant to be a kind af basic_files
  # in order for this module to work a class must inherit from ActiveFedora::Base
  # it is meant to be included in the basic_files classes
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
        m.field "file_uuid", :string
      end

      delegate_to 'techMetadata', [:last_modified, :created, :last_accessed, :original_filename, :mime_type, :file_uuid], :multiple => false
      delegate_to 'descMetadata', [:description], :multiple => false
      # TODO have more than one checksum (both MD5 and SHA), and specify their checksum algorithm.
      delegate :checksum, :to => 'techMetadata', :at => [:file_checksum], :multiple => false
      delegate :size, :to => 'techMetadata', :at => [:file_size], :multiple => false
    end

    # adds a content datastream to the object and generate techMetadata for the basic_files
    # basic_files must have the following methods [size, content_type, original_filename, tempfile]
    # return true if successful, else false
    def add_file(file, skip_file_characterisation)
      valid_file = check_file?(file)
      if (valid_file)
        self.add_file_datastream(file.tempfile, :label => file.original_filename, :mimeType => file.content_type, :dsid => 'content')
        if skip_file_characterisation.eql? nil
          self.add_fits_metadata_datastream(file)
        end
        set_file_timestamps(file.tempfile)
        self.checksum = generate_checksum(file.tempfile)
        self.original_filename = file.original_filename
        self.mime_type = file.content_type
        self.size = file.size
        self.file_uuid = UUID.new.generate
      end
      valid_file
    end

    #function for extracting FITS metadata from the file data associated with this BasicFile
    #and storing the XML produced as a datastream on the BasicFile Fedora object.
    #If something goes wrong with the file extraction, the RuntimeError is caught, logged and the function
    #will return allowing normal processing of the BasicFile to continue
    #TODO place some sensible limit on the file size so far we don't know what the upper limit should be
    def add_fits_metadata_datastream(file)
      puts 'FITS_HOME='
      puts ENV['FITS_HOME'].to_s
      #puts File.size(file.tempfile.path)
      puts 'Characterizing file using FITS tool'
      begin
        fitsMetadata = Hydra::FileCharacterization.characterize(file, file.original_filename, :fits)
      rescue Hydra::FileCharacterization::ToolNotFoundError => tnfe
        logger.error tnfe.to_s
        puts tnfe.to_s
        logger.error 'Tool for extracting FITS metadata not found, continuing with normal processing...'
        puts 'Tool for extracting FITS metadata not found, continuing with normal processing...'
        return
      rescue RuntimeError => re
        logger.error 'Something went wrong with extraction of file metadata using FITS'
        puts 'Something went wrong with extraction of file metadata using FITS'
        logger.error re.to_s
        puts re.to_s
        logger.error 'Continuing with normal processing...'
        puts 'Continuing with normal processing...'
        return
      end
      puts fitsMetadata.to_s
      fitsDatastream = ActiveFedora::OmDatastream.from_xml(fitsMetadata)

      self.add_datastream(fitsDatastream, {:prefix => 'fitsMetadata'})
      self.save
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

    #returns true if basic_files has all the methods that is needed by #add_file else false is returned
    def check_file?(file)
      file_methods = [:size, :tempfile, :content_type, :original_filename,]
      file_methods.each do |method_name|
        unless file.respond_to?(method_name)
          logger.error "basic_files doesn't support #{method_name} method"
          return false
        end
      end
      true
    end
  end
end
