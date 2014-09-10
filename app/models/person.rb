class Person < AuthorityMetadataUnit
  has_attributes :firstName, :surname, :dateOfBirth, :dateOfDeath, datastream: 'descMetadata', :multiple => false

  include Concerns::Inheritance

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