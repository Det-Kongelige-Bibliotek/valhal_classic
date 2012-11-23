# -*- encoding : utf-8 -*-

class Book < ActiveFedora::Base

  has_metadata :name=>'descMetadata', :type=>Datastreams::BookModsDatastream

  delegate_to 'descMetadata',[:uuid, :local_id, :genre], :unique=>true
  delegate_to 'descMetadata',[:shelf_location]
  delegate :title, :to =>'descMetadata', :at=>[:titleInfo, :title], :unique=>true

end
