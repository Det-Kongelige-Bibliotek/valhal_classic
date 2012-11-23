# -*- encoding : utf-8 -*-

class Book < ActiveFedora::Base

  has_metadata :name=>'descMetadata', :type=>Datastreams::BookModsDatastream

  delegate_to 'descMetadata',[:uuid, :local_id, :genre], :unique=>true
  delegate :shelfLocator, :to =>'descMetadata', :at=>[:location, :shelfLocator], :unique=>true
  delegate :title, :to =>'descMetadata', :at=>[:titleInfo, :title], :unique=>true
end
