# -*- encoding : utf-8 -*-
# This is the abstract person class.
# It is intended to represent the manifestation of a person, which may refer to specific
# representations of this person, e.g. a TEI encoded author-description, an image, etc.
# The person must have a relationship to the different intellectual entities it has been
# involved in, e.g. authored a book, performed a play, etc.
class Person < IntellectualEntity
  # Descriptive metadata stream for the abstract person.
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream do |m|
    m.field "name", :string
  end

  # Define the name of the person as an accessible part of the descriptive metadata.
  delegate_to 'descMetadata', [:name], :unique => true

  # Validation criteria of the name (at least 1 non-space character).
  validates :name, :presence => true, :length => { :minimum => 1 }

  # TODO find better relationship property.
  # Relationship to TEI representations.
  has_many :tei, :class_name => 'PersonTeiRepresentation', :property=>:is_constituent_of

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
end
