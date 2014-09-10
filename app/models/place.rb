class Place < AuthorityMetadataUnit
  has_attributes :placeName, datastream: 'descMetadata', :multiple => false

  def assert_content_model
    super()
    object_superclass = self.class.superclass
    until object_superclass == ActiveFedora::Base || object_superclass == Object do
      add_relationship(:has_model, object_superclass.to_class_uri)
      object_superclass = object_superclass.superclass
    end
  end

  def set_value
    self.value = self.placeName
  end

  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'person_placeName', method: :placeName, :index_as => [:string, :stored, :indexed]
  end

end