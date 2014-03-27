# -*- encoding : utf-8 -*-
# This is the abstract person class.
# It is intended to represent the manifestation of a person, which may refer to specific
# representations of this person, e.g. a TEI encoded author-description, an image, etc.
# The person must have a relationship to the different intellectual entities it has been
# involved in, e.g. authored a book, performed a play, etc.
class Person < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::IntellectualEntity
  include Concerns::Person::Author
  include Concerns::Person::Concerning
  include Concerns::Person::Portrait
  include Concerns::Preservation
  include Solr::Indexable

  # Descriptive metadata stream for the abstract person.
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream do |m|
    m.field 'firstname', :string
    m.field 'lastname', :string
    m.field 'date_of_birth', :string
    m.field 'date_of_death', :string
  end

  # Define the name of the person as an accessible part of the descriptive metadata.
  has_attributes :firstname, :lastname, :date_of_birth, :date_of_death, datastream: 'descMetadata', :multiple => false

  # Validation criteria of the lastname (at least 1 non-space character).
  validates :lastname, :presence => true, :length => {:minimum => 1}
  validates_with PersonValidator

  def name
    "#{firstname.to_s} #{lastname.to_s}"
  end

  def comma_separated_lastname_firstname
    "#{lastname.to_s}, #{firstname.to_s}"
  end

  # @return whether its preservation can be inherited. For the person, this is false.
  def preservation_inheritance?
    return false
  end

  has_solr_fields do |m|
    m.field "search_result_title", method: :comma_separated_lastname_firstname
    m.field "person_name", method: :comma_separated_lastname_firstname, :index_as => [:string, :indexed, :stored]
  end
end
