class Person < AuthorityMetadataUnit
  has_attributes :firstName, :surname, :dateOfBirth, :dateOfDeath, datastream: 'descMetadata', :multiple => false

  def assert_content_model
    super()
    object_superclass = self.class.superclass
    until object_superclass == ActiveFedora::Base || object_superclass == Object do
      add_relationship(:has_model, object_superclass.to_class_uri)
      object_superclass = object_superclass.superclass
    end
  end


  def set_value
      newval = "#{self.surname}"
      newval += ", #{self.firstName}" unless self.firstName.blank?
      newval += " "
      newval += "#{self.dateOfBirth}" unless self.dateOfBirth.blank?
      newval += " - #{self.dateOfDeath}" unless self.dateOfDeath.blank?
      self.value = newval
  end

  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'person_firstName', method: :firstName, :index_as => [:string, :stored, :indexed]
    m.field 'person_surName', method: :surname, :index_as => [:string, :stored, :indexed]
    m.field 'person_dateOfBirth', method: :dateOfBirths, :index_as => [:string, :stored, :indexed]
    m.field 'person_dateOfDeath', method: :dateOfDeath, :index_as => [:string, :stored, :indexed]
  end

end