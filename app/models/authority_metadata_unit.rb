# -*- encoding : utf-8 -*-
# Uses the configurations METADATA_RELATIONS_CONFIG and AMU_TYPES
class AuthorityMetadataUnit < ActiveFedora::Base
  include Concerns::AMURelations
  include Solr::Indexable

  has_metadata :name => 'descMetadata', :type => Datastreams::AuthorityDescMetadata


  # List of non-multiple key-value pairs
  has_attributes :type, :value, datastream: 'descMetadata', :multiple => false

  # List of multiple key-value pairs
  has_attributes :reference, datastream: 'descMetadata', :multiple => true

  validates_with AMUValidator

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

  # The fields for the SOLR index.
  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'amu_type', method: :type, :index_as => [:string, :stored, :indexed]
    m.field 'amu_value', method: :value, :index_as => [:string, :stored, :indexed]
    m.field 'amu_reference', method: :reference, :index_as => [:string, :stored, :indexed, :multivalued]
  end
end
