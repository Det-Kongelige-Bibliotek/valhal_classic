class Place < AuthorityMetadataUnit
  has_attributes :name, datastream: 'descMetadata', :multiple => false

  include Concerns::Inheritance

  def set_value
    self.value = self.name
  end

  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'person_placeName', method: :placeName, :index_as => [:string, :stored, :indexed]
  end

end