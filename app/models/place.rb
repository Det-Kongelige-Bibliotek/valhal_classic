class Place < AuthorityMetadataUnit
  has_attributes :name, datastream: 'descMetadata', :multiple => false

  include Concerns::Inheritance

  def set_value_and_type
    self.value = self.name
    self.type = 'place'
  end

  has_solr_fields do |m|
    # Fields from DescMetadata
    m.field 'person_placeName', method: :placeName, :index_as => [:string, :stored, :indexed]
  end

  #Function to retrieve all Person related data stored in the search engine
  #@return Array of Solr search results for people
  def self.get_search_objs
    ActiveFedora::SolrService.query("#{self.solr_names[:amu_value]}:* && active_fedora_model_ssi:Place",
                                    {:rows => ActiveFedora::SolrService.count("#{self.solr_names[:amu_value]}:* && active_fedora_model_ssi:Place")})
  end

end