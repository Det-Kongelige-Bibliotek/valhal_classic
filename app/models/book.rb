# -*- encoding : utf-8 -*-

class Book < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name=>'descMetadata', :type=>Datastreams::BookMods

  delegate_to 'descMetadata',[:uuid, :isbn, :genre, :shelfLocator, :title, :subTitle, :typeOfResource, :publisher,
                              :originPlace, :languageISO, :languageText, :subjectTopic, :dateIssued,
                              :physicalExtent], :unique=>true

  # has_many is used as there doesn't seem to be any has_one relation in Active Fedora
  has_many :BookTeiRepresentation, :property=>:is_part_of
end
