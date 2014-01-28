# -*- encoding : utf-8 -*-
module Concerns

  # GenericFile contains tha basic functionality for a class meant to be a kind af basic_files
  # in order for this module to work a class must inherit from ActiveFedora::Base
  # it is meant to be included in the generic_files classes
  # Example:
  # Class TiffFile < ActiveFedora::Base
  # include Concerns::GenericFile
  module GenericFile
    extend ActiveSupport::Concern
    include Hydra::Models::FileAsset

    included do
      include Concerns::IntellectualEntity
      include Concerns::Preservation
      # a ActiveFedora::SimpleDatastream for the techMetadata
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

      has_attributes :last_modified, :created, :last_accessed, :original_filename, :mime_type, :file_uuid,
                     datastream: 'techMetadata', :multiple => false
      has_attributes :description, datastream: 'descMetadata', :multiple => false
      # TODO have more than one checksum (both MD5 and SHA), and specify their checksum algorithm.
      has_attributes :checksum, datastream: 'techMetadata', :at => [:file_checksum], :multiple => false
      has_attributes :size, datastream: 'techMetadata', :at => [:file_size], :multiple => false
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

    #function for extracting FITS metadata from the file data associated with this GenericFile
    #and storing the XML produced as a datastream on the GenericFile Fedora object.
    #If something goes wrong with the file extraction, the RuntimeError is caught, logged and the function
    #will return allowing normal processing of the GenericFile to continue
    def add_fits_metadata_datastream(file)
      logger.info 'Characterizing file using FITS tool'
      begin
        fits_home = `echo $FITS_HOME`
        logger.debug "fits_home = #{fits_home}"
        `alias fits=$FITS_HOME` #dirty hack to overcome problem in sh environment
        fitsMetadata = Hydra::FileCharacterization.characterize(file, file.original_filename, :fits)
      rescue Hydra::FileCharacterization::ToolNotFoundError => tnfe
        logger.error tnfe.to_s
        logger.error 'Tool for extracting FITS metadata not found, check FITS_HOME environment variable is set and valid installation of fits is present'
        logger.error 'Continuing with normal processing...'
        puts tnfe.to_s
        puts 'Tool for extracting FITS metadata not found, check FITS_HOME environment variable is set and valid installation of fits is present'
        return
      rescue RuntimeError => re
        logger.error 'Something went wrong with extraction of file metadata using FITS'
        logger.error re.to_s
        logger.error 'Continuing with normal processing...'
        puts re.to_s
        puts 'Something went wrong with extraction of file metadata using FITS'
        return
      end
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
      false
    end

    # @return whether its preservation can be inherited. For the files, this is false.
    def preservation_inheritance?
      false
    end

    # @return the path for updating the preservation metadata
    def update_preservation_metadata_uri
      update_preservation_metadata_basic_file_url(self)
    end

    # @return the uri for downloading the file.
    def content_uri
      download_basic_file_url(self)
    end

    private
    def generate_checksum(file)
      Digest::MD5.file(file).hexdigest
    end

    # Extracts the timestamps from the file and inserts them into the technical metadata.
    # @param file The file to extract the timestamps of.
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
