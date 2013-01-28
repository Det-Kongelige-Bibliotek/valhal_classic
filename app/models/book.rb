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

  # Determines whether any TEI representations exists.
  def tei_rep?

    #logger.debug "has tei = " + tei.any?.to_s
    #logger.debug "###################################################"
    #unless self.tei.nil? || self.tei[0].nil?
    #  logger.debug self.tei[0].datastreams.size
    #  self.tei[0].datastreams.each do |d|
    #    logger.debug d.to_yaml
    #  end
    #end

    #logger.debug "###################################################"
    #logger.debug "has tei rep = " + tei_rep?.any?.to_s
    return tei.any?
  end

  # Determines whether any TIFF representations exists.
  def hasTiffRep?

    #logger.debug "has tiff = " + tif.any?.to_s
    #logger.debug "###################################################"
    #unless self.tif.nil? || self.tif[0].nil?
    #  logger.debug self.tif[0].datastreams.size
    #  self.tif[0].datastreams.each do |d|
    #    logger.debug d.to_yaml
    #  end
    #end
    #logger.debug datastreams.size
    #logger.debug "###################################################"
    return tif.any?
  end

  # Whether any author for this book has been defined.
  def has_author?
    return authors.any?
  end
end
