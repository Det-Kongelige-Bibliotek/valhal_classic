# -*- encoding : utf-8 -*-
# Uses the configurations METADATA_RELATIONS_CONFIG and AMU_TYPES
class AuthorityMetadataUnit < ActiveFedora::Base
  include Concerns::AMURelations
  include Solr::Indexable

  has_metadata :name => 'descMetadata', :type => Datastreams::AuthorityDescMetadata


  # List of non-multiple key-value pairs
  has_attributes :type, :value,  datastream: 'descMetadata', :multiple => false

  # List of multiple key-value pairs
  has_attributes :reference, datastream: 'descMetadata', :multiple => true

  # Validation should be done in the subclasses
  #validates_with AMUValidator

  before_save :set_value_and_type

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

  # The fields for the SOLR index.
  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'search_result_title', method: :value, :index_as => [:text, :stored, :indexed]
    m.field 'amu_type', method: :type, :index_as => [:string, :stored, :indexed]
    m.field 'amu_value', method: :get_value_without_special_characters, :index_as => [:string, :stored, :indexed]
    m.field 'amu_reference', method: :reference, :index_as => [:string, :stored, :indexed, :multivalued]
  end

  def set_value_and_type

  end

  def self.get_agent(id)
    agent = AuthorityMetadataUnit.find(id)
    case agent.type
      when 'agent/person'
        val = Person.find(id)
      when 'place'
        val = Place.find(id)
      else
        val = AuthorityMetadataUnit.find(id)
    end
    val
  end

end
