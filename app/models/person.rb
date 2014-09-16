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
    m.field 'person_lastName', method: :lastName, :index_as => [:string, :stored, :indexed]
    m.field 'person_dateOfBirth', method: :dateOfBirth, :index_as => [:string, :stored, :indexed]
    m.field 'person_dateOfDeath', method: :dateOfDeath, :index_as => [:string, :stored, :indexed]
  end

  # Given a string, convert it to a firstname lastname combi
  # and find or create a person object on this basis
  def self.from_string(name_string)
    name = name_from_string(name_string)
    search_fields = person_search_fields(name)
    results = Person.find(search_fields)
    if results.size == 0
      Person.create(name)
    else
      results.first
    end
  end


  # Convert a string representing a name to a firstname, lastname hash
  # At present can only handle <lastname, firstname> format
  # e.g. "Joyce, James" => { lastName: 'Joyce', firstName: 'James' }
  def self.name_from_string(name_string)
    arr = name_string.split(',').map{ |e| e.strip }
    {lastName: arr.first, firstName: arr.second}
  end


  # Create a hash of Solr search fields
  # based on a hash of attributes
  # e.g. {lastName: 'Joyce'} => {"person_lastName_ssi"=>"Joyce"}
  def self.person_search_fields(hash)
    fields = {}
    hash.keys.each do |key|
      self.solr_fields.each do |field|
        if field.name.include?(key.to_s)
          fields[field.solr_name] = hash[key]
        end
      end
    end
    fields
  end

end