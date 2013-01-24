# -*- encoding : utf-8 -*-
class PersonTeiRepresentation < ActiveFedora::Base

  has_metadata :name => 'descMetadata', :type => Datastreams::AdlTeiP5
  has_file_datastream :name => "teiFile", :type => Datastreams::AdlTeiP5
  #has_file_datastream :name => 'authorImageFile', :type => ActiveFedora::Datastream

  delegate_to 'descMetadata', [:forename, :surname, :date_of_birth, :date_of_death, :period], :unique => true
  delegate_to 'descMetadata', [:short_biography, :sample_quotation, :sample_quotation_source]
  #delegate_to 'authorImageFile', [:author_image_file]

  # Relationship to be abstract Person
  belongs_to :person, :property => :is_constituent_of

  def to_solr(solr_doc = {})
    super
    solr_doc["forename_t"] = self.forename unless self.forename.blank?
    solr_doc["surname_t"] = self.surname unless self.surname.blank?
    solr_doc["birth_date_t"] = self.date_of_birth unless self.date_of_birth.blank?
    solr_doc["death_date_t"] = self.date_of_death unless self.date_of_death.blank?
    solr_doc["sample_quotation_t"] = self.sample_quotation unless self.sample_quotation.blank?
    solr_doc["sample_quotation_source_t"] = self.sample_quotation_source unless self.sample_quotation_source.blank?
    return solr_doc

  end
end
