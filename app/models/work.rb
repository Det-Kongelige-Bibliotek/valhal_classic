# -*- encoding : utf-8 -*-
class Work < IntellectualEntity
  include ActiveModel::Validations

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name=>'descMetadata', :type=>Datastreams::WorkMods

  # TODO define restrictions for these metadata fields.
  delegate_to 'descMetadata',[:shelfLocator, :title, :subTitle, :typeOfResource, :publisher,
                              :originPlace, :languageISO, :languageText, :subjectTopic, :dateIssued,
                              :physicalExtent], :unique=>true
  delegate :work_type, :to => 'descMetadata', :at => [:genre], :unique => true

  # A book can be authored by more than one person, and a person can author more than one book.
  has_and_belongs_to_many :authors, :class_name=>"Person", :property => :has_author

  # A work can have many representations
  has_many :representations, :class_name => 'SingleFileRepresentation', :property=>:is_representation_of

  validates :title, :presence => true
  validates :work_type, :presence => true

  # Determines whether any representations exists.
  def has_rep?
    return representations.any?
  end

  # Whether any author for this book has been defined.
  def has_author?
    return authors.any?
  end

  def to_solr(solr_doc = {})
    super
    #search_result_title_t = the name of the field in the Solr document that will be used on search results
    #to create a link, we use this field for both Books and Persons so that we can make a link to in the search results
    #view using
    solr_doc["search_result_title_t"] = self.title unless self.title.blank?
    solr_doc["search_result_work_type_t"] = self.work_type unless self.work_type.blank?

    solr_doc["shelf_locator_t"] = self.shelfLocator unless self.shelfLocator.blank?
    solr_doc["title_t"] = self.title unless self.title.blank?
    solr_doc["sub_title_t"] = self.subTitle unless self.subTitle.blank?
    solr_doc["type_of_resource_t"] = self.typeOfResource unless self.typeOfResource.blank?
    return solr_doc
  end

end
