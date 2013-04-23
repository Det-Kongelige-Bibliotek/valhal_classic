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
  validates :firstname, :presence => true, :length => {:minimum => 1}
  validates :lastname, :presence => true, :length => {:minimum => 1}
  validates_with PersonValidator

  # TODO find better relationship property.
  # Relationship to TEI representations.
  has_many :tei, :class_name => 'ActiveFedora::Base', :property => :is_representation_of, :inverse_of => :has_representation
  has_many :person_image_representation, :class_name => 'ActiveFedora::Base', :property => :is_representation_of, :inverse_of => :has_representation

  # Author relationship to manifestations.
  # A book can be authored by more than one person, and a person can author more than one book.
  has_and_belongs_to_many :authored_books, :class_name => "Book", :property => :is_author_of, :inverse_of => :has_author
  # A work can be authored by more than one person, and a person can author more than one work.
  has_and_belongs_to_many :authored_works, :class_name => "Work", :property => :is_author_of, :inverse_of => :has_author

  # A person can be described by more than one book, and a book can describe more than one person
  has_and_belongs_to_many :describing_books, :class_name => "Book", :property => :has_description, :inverse_of => :is_description_of
  # A person can be described by more than one work, and a work can describe more than one person
  has_and_belongs_to_many :describing_works, :class_name => "Work", :property => :has_description, :inverse_of => :is_description_of

  # Determines whether any TEI representations exists.
  def tei_rep?
    tei.any?
  end

  # Determines whether any book has been authored by this person.
  def is_author_of_book?
    authored_books.any?
  end

  # Determines whether any work has been authored by this person.
  def is_author_of_work?
    authored_works.any?
  end

  # Determines whether any book describes this person.
  def is_described_by_book?
    describing_books.any?
  end

  # Determines whether any work describes this person.
  def is_described_by_work?
    describing_works.any?
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

  after_save :add_ie_to_reps

  def add_ie_to_reps
    add_ie_to_rep tei
    add_ie_to_rep person_image_representation
  end

  def add_ie_to_rep(rep_array)
    if rep_array
      rep_array.each do |rep|
        if rep.ie.nil?
          rep.ie = self
          rep.save
        end
      end
    end
  end
end
