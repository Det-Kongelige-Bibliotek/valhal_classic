# -*- encoding : utf-8 -*-

class BasicFile < ActiveFedora::Base
  include Hydra::Models::FileAsset

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  # a ActiveFedora::SimpleDatastream for the techMetadata
  # TODO find out if we need to make our own Datastream for techMetadata
  has_metadata :name => 'techMetadata', :type => ActiveFedora::SimpleDatastream do |m|
    m.field "last_modified", :string
    m.field "created", :string
    m.field "last_accessed", :string
    m.field "file_checksum", :string
    m.field "original_filename", :string
    m.field "mime_type", :string
    m.field "file_size", :integer
  end

  delegate_to 'techMetadata', [:last_modified, :created, :last_accessed, :original_filename, :mime_type], :unique => true
  delegate_to 'descMetadata', [:description], :unique => true
  delegate :checksum, :to => 'techMetadata', :at => [:file_checksum], :unique => true
  delegate :size, :to => 'techMetadata', :at => [:file_size], :unique => true

  # adds a content datastream to the object and generate techMetadata for the file
  # file must have the following methods [size, content_type, original_filename, atime, ctime, mtime]
  # return true if successful, else false
  def add_file(file)
    vaild_file = check_file?(file)
    if (vaild_file)
      self.add_file_datastream(file.tempfile, :label => file.original_filename, :mimeType => file.content_type, :dsid => 'content')
      set_file_timestamps(file.tempfile)
      self.checksum = generate_checksum(file.tempfile)
      self.original_filename = file.original_filename
      self.mime_type = file.content_type
      self.size = file.size
    end
    vaild_file
  end

  private
  def generate_checksum(file)
    Digest::MD5.file(file).hexdigest
  end

  private
  def set_file_timestamps(file)
    self.created = file.ctime.to_s
    self.last_accessed = file.atime.to_s
    self.last_modified = file.mtime.to_s
  end

  #returns true if file has all the methods that is needed by in #add_file else false is returned
  private
  def check_file?(file)
    @@file_methods = [:size, :tempfile, :content_type, :original_filename, ]
    @@file_methods.each do |method_name|
      unless file.respond_to?(method_name)
        puts "file doenst have #{method_name}"
        return false
      end
    end
    true
  end

end
