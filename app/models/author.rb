# -*- encoding : utf-8 -*-

class Author < ActiveFedora::Base

  has_metadata :name=>'descMetadata', :type=>Datastreams::Mods
  has_metadata :name=>'TEI_P5', :type=>Datastreams::AdlTeiP5Datastream

  delegate :author_name, :to =>''
end
