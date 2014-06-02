# -*- encoding : utf-8 -*-
class AuthorityMetadataUnit < ActiveFedora::Base
  #include Solr::Indexable

  has_metadata :name => 'descMetadata', :type => Datastreams::AuthorityDescMetadata

  # Can be a topic for many works
  has_and_belongs_to_many :topic, :class_name => 'ActiveFedora::Base', :property=>:topic
  # Can be a topic for many works
  has_and_belongs_to_many :geographic, :class_name => 'ActiveFedora::Base', :property=>:geographic
  # Can be a topic for many works
  has_and_belongs_to_many :created, :class_name => 'ActiveFedora::Base', :property=>:created

  # List of non-multiple key-value pairs
  has_attributes :type, :value, datastream: 'descMetadata', :multiple => false

  # List of multiple key-value pairs
  has_attributes :reference, datastream: 'descMetadata', :multiple => true

  # The fields for the SOLR index.
#  has_solr_fields do |m|
    # Fields from DescMetadata
#    m.field 'authority_type', method: descMetadata.type, :index_as => [:string, :indexed, :stored]
#    m.field 'authority_value', method: :value, :index_as => [:string, :indexed, :stored]
#    m.field 'authority_reference', method: :reference, :index_as => [:string, :indexed, :stored]
#  end
end
