# -*- encoding : utf-8 -*-
class BasicFile < ActiveFedora::Base
  include Concerns::IntellectualEntity
  include Concerns::BasicFile

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata


  def to_solr(solr_doc = {})
    super
    solr_service = ActiveFedora::SolrService
    desc = Solrizer::Descriptor.new(:text, :stored, :indexed)
    solr_doc[ActiveFedora::SolrService.solr_name("title", desc)] = self.original_filename.gsub("_", " ").gsub(".xml", "") unless self.original_filename == nil
    return solr_doc
  end



end
