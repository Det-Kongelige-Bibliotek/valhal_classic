class BasicFile < ActiveFedora::Base
  include Hydra::Models::FileAsset

  has_metadata :name =>'techMetadata', :type => ActiveFedora::SimpleDatastream do |m|
    m.field "last_modified", :string
    m.field "created", :string
    m.field "last_accessed", :string
    m.field "file_checksum", :string
    m.field "original_filename", :string
    m.field "mime_type", :string
  end

  delegate_to 'techMetadata', [:last_modified, :created, :last_accessed, :original_filename, :mime_type], :unique => true

  delegate :checksum, :to => 'techMetadata', :at => [:file_checksum], :unique => true

  delegate_to 'descMetadata', [:description], :unique => true

  #adds a content datastream to the object and generate techMetadata for the file
  #@return true if successful, else false
  def add_file(file)
    self.add_file_datastream(file, :label => file.original_filename, :mimeType => file.content_type, :dsid => 'content')
    set_file_timestamps(file)
    self.checksum = generate_checksum(file)
    self.original_filename = file.original_filename
    self.mime_type = file.content_type
    true
  end

  private
  def generate_checksum(file)
    checksum = Digest::MD5.file(file).hexdigest
  end

  private
  def set_file_timestamps(file)
    self.created = file.ctime.to_s
    self.last_accessed = file.atime.to_s
    self.last_modified = file.mtime.to_s
  end

end
