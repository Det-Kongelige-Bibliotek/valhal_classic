# -*- encoding : utf-8 -*-
# This is the abstract person class.
# It is intended to represent the manifestation of a person, which may refer to specific
# representations of this person, e.g. a TEI encoded author-description, an image, etc.
# The person must have a relationship to the different intellectual entities it has been
# involved in, e.g. authored a book, performed a play, etc.
class Person < ActiveFedora::Base
  include ActiveModel::Validations
  include Concerns::IntellectualEntity
  include Solr::Indexable

  # Descriptive metadata stream for the abstract person.
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream do |m|
    m.field "firstname", :string
    m.field "lastname", :string
    m.field "date_of_birth", :string
    m.field "date_of_death", :string
  end

  # Define the name of the person as an accessible part of the descriptive metadata.
  delegate_to 'descMetadata', [:firstname, :lastname, :date_of_birth, :date_of_death], :unique => true

  # Validation criteria of the firstname (at least 1 non-space character).
  validates :firstname, :presence => true, :length => { :minimum => 1 }
  validates :lastname, :presence => true, :length => { :minimum => 1 }
  validates_with PersonValidator

  # TODO find better relationship property.
  # Relationship to TEI representations.
  has_many :tei, :class_name => 'PersonTeiRepresentation', :property=>:is_representation_of
  has_many :person_image_representation, :class_name => 'PersonImageRepresentation', :property=>:is_representation_of

  # Author relationship to books.
  # A book can be authored by more than one person, and a person can author more than one book.
  has_and_belongs_to_many :authored_books, :class_name=>"Book", :property => :is_author_of

  # Determines whether any TEI representations exists.
  def tei_rep?
    tei.any?
  end

  # Determines whether any book has been authored by this person.
  def is_author?
    authored_books.any?
  end

  # Determines whether any portrait images has been defined for this person.
  def has_portrait?
    person_image_representation.any?
  end

  def name
    "#{firstname.to_s} #{lastname.to_s}"
  end

  def comma_seperated_lastname_firstname
    "#{firstname.to_s}, #{lastname.to_s}"
  end

  has_solr_fields do |m|
    m.field "search_result_title", method: :comma_seperated_lastname_firstname
    m.field "person_name", method: :name
  end

end
