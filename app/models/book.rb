# -*- encoding : utf-8 -*-

class Book < ActiveFedora::Base

  has_metadata :name=>'descMetadata', :type=>Datastreams::BookMods

  delegate_to 'descMetadata',[:uuid, :isbn, :genre, :shelfLocator,
                              :title, :subTitle, :typeOfResource, :publisher,
                              :originPlace, :languageISO, :languageText, :subjectTopic], :unique=>true
end
