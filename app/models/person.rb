# -*- encoding : utf-8 -*-
# This is the abstract person class.
# It is intended to represent the manifestation of a person, which may refer to specific
# representations of this person, e.g. a TEI encoded author-description, an image, etc.
# The person must have a relationship to the different intellectual entities it has been
# involved in, e.g. authored a book, performed a play, etc.
class Person < IntellectualEntity
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

  # TODO find better relationship property.
  # Relationship to TEI representations.
  has_many :tei, :class_name => 'PersonTeiRepresentation', :property=>:is_representation_of
  has_many :person_image_representation, :class_name => 'PersonImageRepresentation', :property=>:is_representation_of

  # Author relationship to books.
  # A book can be authored by more than one person, and a person can author more than one book.
  has_and_belongs_to_many :authored_books, :class_name=>"Book", :property => :is_author_of

  # Determines whether any TEI representations exists.
  def tei_rep?
    return tei.any?
  end

  # Determines whether any book has been authored by this person.
  def is_author?
    return authored_books.any?
  end

  # Determines whether any portrait images has been defined for this person.
  def has_portrait?
    return person_image_representation.any?
  end

  def name
    return firstname.to_s + " " + lastname.to_s
  end

  def comma_seperated_lastname_firstname
    return lastname.to_s + ", " + firstname.to_s
  end

  def to_solr(solr_doc = {})
    super
    #search_result_title_t = the name of the field in the Solr document that will be used on search results
    #to create a link, we use this field for both Books and Persons so that we can make a link to in the search results
    #view using
    solr_doc["search_result_title_t"] = self.comma_seperated_lastname_firstname unless self.comma_seperated_lastname_firstname.blank?

    solr_doc["person_name_t"] = self.name unless self.name.blank?
    return solr_doc

  end
end
