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

  # validates whether a date is equal to the defined birthday of this person
  # returns true if either both are undefined or they are identical.
  def is_same_birth_day(date)
    if date.nil? && :date_of_birth.nil?
      return true
    end
    if date.nil? || :date_of_birth.nil?
      return false
    end

    return date == :date_of_birth
  end

  # validates whether a date is equal to the defined day of death of this person
  # returns true if either both are undefined or they are identical.
  def is_same_death_day(date)
    if date.nil? && :date_of_death.nil?
      return true
    end
    if date.nil? || :date_of_death.nil?
      return false
    end

    return date == :date_of_death
  end

  # Determines whether any other person exists with the same name, birthday and deathday
  def is_duplicate_person?
    logger.debug "Looking for duplicate people with name = #{comma_seperated_lastname_firstname}"
    if id.eql? "__DO_NOT_USE__"
      potential_people = ActiveFedora::SolrService.query("search_result_title_t:#{comma_seperated_lastname_firstname} AND has_model_s:\"info:fedora/afmodel:Person\"")
    else
      logger.debug "self.id = #{self.id}"
      logger.debug "self.pid = #{self.pid}"
      potential_people = ActiveFedora::SolrService.query("search_result_title_t:#{comma_seperated_lastname_firstname} AND has_model_s:\"info:fedora/afmodel:Person\" NOT id:\"#{self.id}\"")
    end
    logger.error "duplicate person names count = #{potential_people.size}"
    potential_people.each do |p|
      person = Person.find(p.id)
      if is_same_birth_day(person.date_of_birth) && is_same_death_day(person.date_of_death)
          errors.add(:name, "cannot be duplicated")
      end
    end
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
