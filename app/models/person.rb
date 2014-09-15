##
#Modeleringa af en person efter følgende
#<foaf:person xmlns:foaf='http://xmlns.com/foaf/0.1/'
# #xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/">
#<foaf:firstname> </foaf:firstname>
#  <foaf:lastname> </foaf:lastname>
#<foaf:title></foaf:title>
# < rdaGr2:dateOfBirth></ rdaGr2:dateOfBirth>
#< rdaGr2:dateOfDeath></ rdaGr2:dateOfDeath>
#</foaf:person>
##

class Person < AuthorityMetadataUnit
  has_attributes :firstName, :lastName, :title, :dateOfBirth, :dateOfDeath, datastream: 'descMetadata', :multiple => false

  include Concerns::Inheritance

  def set_value_and_type
      newval = "#{self.lastName}"
      newval += ", #{self.firstName}" unless self.firstName.blank?
      newval += " "
      newval += "#{self.dateOfBirth}" unless self.dateOfBirth.blank?
      newval += " - #{self.dateOfDeath}" unless self.dateOfDeath.blank?
      self.value = newval
      self.type = 'agent/person'
  end

  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'person_firstName', method: :firstName, :index_as => [:string, :stored, :indexed]
    m.field 'person_surname', method: :lastName, :index_as => [:string, :stored, :indexed]
    m.field 'person_dateOfBirth', method: :dateOfBirth, :index_as => [:string, :stored, :indexed]
    m.field 'person_dateOfDeath', method: :dateOfDeath, :index_as => [:string, :stored, :indexed]
  end

end