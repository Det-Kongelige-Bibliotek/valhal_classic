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
  include Concerns::Person::Described
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

  # Relationship to TEI representations.
  has_many :tei, :class_name => 'ActiveFedora::Base', :property => :is_representation_of, :inverse_of => :has_representation
  has_many :person_image_representation, :class_name => 'ActiveFedora::Base', :property => :is_representation_of, :inverse_of => :has_representation

  # Determines whether any TEI representations exists.
  def tei_rep?
    tei.any?
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
