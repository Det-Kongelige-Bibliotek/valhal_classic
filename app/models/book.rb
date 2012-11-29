# -*- encoding : utf-8 -*-

class Book < ActiveFedora::Base

  has_metadata :name=>'descMetadata', :type=>Datastreams::BookMods

  delegate_to 'descMetadata',[:uuid, :local_id, :genre, :shelfLocator, :title], :unique=>true
end
