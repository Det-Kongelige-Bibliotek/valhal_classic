# -*- encoding : utf-8 -*-
class Book < IntellectualEntity

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name=>'descMetadata', :type=>Datastreams::BookMods

  # TODO define restrictions for these metadata fields.
  delegate_to 'descMetadata',[:isbn, :genre, :shelfLocator, :title, :subTitle, :typeOfResource, :publisher,
                              :originPlace, :languageISO, :languageText, :subjectTopic, :dateIssued,
                              :physicalExtent], :unique=>true

  # has_many is used as there doesn't seem to be any has_one relation in Active Fedora
  has_many :tei, :class_name => 'BookTeiRepresentation', :property=>:is_representation_of
  # A book can be authored by more than one person, and a person can author more than one book.
  has_and_belongs_to_many :authors, :class_name=>"Person", :property => :has_author

  has_many :tif, :class_name => 'BookTiffRepresentation', :property=>:is_part_of

  validates :title, :presence => true
  validates :isbn, :numericality => true, :allow_blank => true
  validate :is_duplicate_isbn?

  # Determines whether any TEI representations exists.
  def tei_rep?
    return tei.any?
  end

  # Determines whether any TIFF representations exists.
  def hasTiffRep?
    return tif.any?
  end

  def is_duplicate_isbn?
    logger.debug ":isbn.blank? = #{isbn.blank?}"
    logger.debug ":isbn = #{isbn}"
    if isbn.blank?
      logger.debug "Returning false as the ISBN is blank"
      false
    else
      if id.eql? "__DO_NOT_USE__"
        count = ActiveFedora::SolrService.query("isbn_t:#{isbn} AND has_model_s:\"info:fedora/afmodel:Book\"").size
      else
        logger.debug "self.id = #{self.id}"
        logger.debug "self.pid = #{self.pid}"
        count = ActiveFedora::SolrService.query("isbn_t:#{isbn} AND has_model_s:\"info:fedora/afmodel:Book\" NOT id:\"#{self.id}\"").size
      end
      logger.error "duplicate ISBN count = #{count}"
      if count > 0 then
        errors.add(:isbn, "cannot be duplicated")
      #else
      #  false
      end
    end
  end

  # Whether any author for this book has been defined.
  def has_author?
    return authors.any?
  end

  def clear_authors
    authors.clear
  end

  # Delivers the title and subtitle in a format for displaying.
  # Should only include the subtitle, if it has been defined.
  def get_title_for_display
    if subTitle == nil || subTitle.empty?
      return title
    else
      return title + ", " + subTitle
    end
  end

  def authors_names_to_s

    unless authors.nil?
      names = []
      authors.each do |a|
        names << a.name
      end
      names.join(", ")
    end

  end

  def to_solr(solr_doc = {})
    super
    #search_result_title_t = the name of the field in the Solr document that will be used on search results
    #to create a link, we use this field for both Books and Persons so that we can make a link to in the search results
    #view using
    solr_doc["search_result_title_t"] = self.title unless self.title.blank?

    solr_doc["search_results_book_authors_s"] = self.authors_names_to_s unless self.authors_names_to_s.blank?
    solr_doc["isbn_t"] = self.isbn unless self.isbn.blank?
    solr_doc["genre_t"] = self.genre unless self.genre.blank?
    solr_doc["shelf_locator_t"] = self.shelfLocator unless self.shelfLocator.blank?
    solr_doc["title_t"] = self.title unless self.title.blank?
    solr_doc["sub_title_t"] = self.subTitle unless self.subTitle.blank?
    solr_doc["type_of_resource_t"] = self.typeOfResource unless self.typeOfResource.blank?
    return solr_doc
  end
end
