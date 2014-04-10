# -*- encoding : utf-8 -*-
require 'open3'
require 'tempfile'
require 'net/http'
require 'fileutils'

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
      # TODO have more than one checksum (both MD5 and SHA), and specify their checksum algorithm.
      has_attributes :checksum, datastream: 'techMetadata', :at => [:file_checksum], :multiple => false
      has_attributes :size, datastream: 'techMetadata', :at => [:file_size], :multiple => false

      has_attributes :description, datastream: 'descMetadata', :multiple => false
      has_metadata :name => 'fitsMetadata1', :type => ActiveFedora::OmDatastream
    end

    # fetches file from external URL and adds a content datatream to the object
    # using the add_file methom
    def add_file_from_url(url, skip_file_characterisation)
      valid_file=false
      file = fetch_file_from_url(url)
      if (file)
        add_file(file, skip_file_characterisation)
      else
        false
      end
    end

    # Add file retrieved from file server
    # Skips file-characterization on the retrieved files.
    def add_file_from_server(pdflink)
      file_download_service = FileDownloadService.new
      file = file_download_service.fetch_file_from_server(File.basename(URI.parse(pdflink).path))
      file.original_filename = File.basename(pdflink)
      file.content_type = 'application/pdf'
      file ? add_file(file, true) : false
      FileUtils.remove_file(file.path)
    end

    # adds a content datastream to the object and generate techMetadata for the basic_files
    # basic_files must have the following methods [size, content_type, original_filename, tempfile]
    # return true if successful, else false
    def add_file(file, skip_file_characterisation)
      valid_file = check_file?(file)
      if (valid_file)
        self.add_file_datastream(file.tempfile, :label => file.original_filename, :mimeType => file.content_type, :dsid => 'content')
        set_file_timestamps(file.tempfile)
        self.checksum = generate_checksum(file.tempfile)
        self.original_filename = file.original_filename
        self.mime_type = file.content_type
        self.size = file.size
        self.file_uuid = UUID.new.generate
        unless skip_file_characterisation
          self.add_fits_metadata_datastream(file)
        end
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
        logger.debug file.class.to_s
        fits_meta_data = Hydra::FileCharacterization.characterize(file, self.original_filename, :fits)
      rescue Hydra::FileCharacterization::ToolNotFoundError => tnfe
        logger.error tnfe.to_s
        logger.error 'Tool for extracting FITS metadata not found, check FITS_HOME environment variable is set and valid installation of fits is present'
        logger.info 'Continuing with normal processing...'
        return
      rescue RuntimeError => re
        logger.error 'Something went wrong with extraction of file metadata using FITS'
        logger.error re.to_s
        logger.info 'Continuing with normal processing...'
        if re.to_s.include? "command not found" #if for some reason the fits command cannot be run from the shell, this hack will get round it
          fits_home = `locate fits.sh`.rstrip
          `export FITS_HOME=#{fits_home}`
          stdin, stdout, stderr = Open3.popen3("#{fits_home} -i #{file.path}")
          fits_meta_data = String.new
          stdout.each_line { |line| fits_meta_data.concat(line) }
        else
          return
        end
      end

      # Ensure UTF8 encoding
      fits_meta_data = fits_meta_data.encode(Encoding::UTF_8)

      # If datastream already exists, then set it
      self.fitsMetadata1.content = fits_meta_data
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

    #fetches a file from a URL
    #returns content from the url. If then url is invalid or no content is returned then the methorn returns nil
    def fetch_file_from_url(url)
      logger.debug "Starting GET of file from #{url}"
      start_time = Time.now
      uri = URI.parse(url)
      if (uri.kind_of?(URI::HTTP))
        resp = Net::HTTP.get_response(uri)
        case resp
          when Net::HTTPSuccess then
            filename = File.basename(uri.path)
            tmpfile = Tempfile.new(filename,Dir.tmpdir)
            File.open(tmpfile.path,'wb+') do |f|
              f.write resp.body
            end
            tmpfile.flush
            file= ActionDispatch::Http::UploadedFile.new(tempfile: tmpfile)
            file.original_filename = filename
            file.content_type = resp.content_type
            logger.debug "GET took #{Time.now - start_time} seconds"
            return file
          else
            logger.error "Could not get file from location #{url} response is #{resp.code}:#{resp.message}"
            return nil
        end
      else
        return nil
      end
    rescue URI::InvalidURIError
      logger.error "Invalid URI #{url}"
      nil
    rescue => e
      logger.error "error in fetch_file_from_url #{url}"
      logger.error e.backtrace.join("\n")
      nil
    end
  end
end
