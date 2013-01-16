# -*- encoding : utf-8 -*-
class Book < IntellectualEntity

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name=>'descMetadata', :type=>Datastreams::BookMods

  # TODO define restrictions for these metadata fields.
  delegate_to 'descMetadata',[:isbn, :genre, :shelfLocator, :title, :subTitle, :typeOfResource, :publisher,
                              :originPlace, :languageISO, :languageText, :subjectTopic, :dateIssued,
                              :physicalExtent], :unique=>true

  # has_many is used as there doesn't seem to be any has_one relation in Active Fedora
  has_many :tei, :class_name => 'BookTeiRepresentation', :property=>:is_part_of
  # A book can be authored by more than one person, and a person can author more than one book.
  has_and_belongs_to_many :authors, :class_name => Person, :property => :is_part_of

  has_many :tif, :class_name => 'BookTiffRepresentation', :property=>:is_part_of

  # Determines whether any TEI representations exists.
  def hasTeiRep
    return tei.any?
  end

  # Determines whether any TEI representations exists.
  def hasTiffRep
    return tif.any?
  end
end
