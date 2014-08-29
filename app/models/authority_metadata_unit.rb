# -*- encoding : utf-8 -*-
# Uses the configurations METADATA_RELATIONS_CONFIG and AMU_TYPES
class AuthorityMetadataUnit < ActiveFedora::Base
  include Concerns::AMURelations
  include Solr::Indexable

  has_metadata :name => 'descMetadata', :type => Datastreams::AuthorityDescMetadata


  # List of non-multiple key-value pairs
  has_attributes :type, :value, :givenName, :surname, :dateOfBirth, :dateOfDeath, datastream: 'descMetadata', :multiple => false

  # List of multiple key-value pairs
  has_attributes :reference, datastream: 'descMetadata', :multiple => true

  validates_with AMUValidator

  before_save :update_value

  # Extracts the relations, which are valid for this
  def get_relations
    res = Hash.new
    relations = METADATA_RELATIONS_CONFIG['authority_metadata_unit'][type]
    get_all_relations.each do |k,v|
      if relations.include?(k) && v.empty? == false
        res[k] = v
      end
    end
    res
  end

  def get_value_without_special_characters
    StringHelper.remove_special_characters(value)
  end

  def display_value
    if value.empty? && type == 'agent/person'
      display = "#{surname}, #{givenName} #{dateOfBirth}"
      display += " - #{dateOfDeath}" unless dateOfDeath.empty?
    else
      display = value
    end
    display
  end

  def update_value
    if type == 'agent/person'
      if surname.blank? && givenName.blank?
        surname = value
      else
        newval = "#{self.surname}, #{self.givenName} #{self.dateOfBirth}"
        newval += " - #{self.dateOfDeath}" unless self.dateOfDeath.empty?
        self.value = newval
      end
    end
  end

  # The fields for the SOLR index.
  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'search_result_title', method: :value, :index_as => [:text, :stored, :indexed]
    m.field 'amu_type', method: :type, :index_as => [:string, :stored, :indexed]
    m.field 'amu_value', method: :get_value_without_special_characters, :index_as => [:string, :stored, :indexed]
    m.field 'amu_reference', method: :reference, :index_as => [:string, :stored, :indexed, :multivalued]
  end

  def all_attributes
    attr = {}
    attr[:type] = type
    if type == 'agent/person'
      attr[:givenName] = givenName
      attr[:surname] = surname
      attr[:dateOfBirth] = dateOfBirth
      attr[:dateOfDeath] = dateOfDeath
    else
      attr[:value] = value
    end
    attr
  end
end
