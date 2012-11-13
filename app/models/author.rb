require 'datastreams/adl_tei_p5'
require 'datastreams/mods'

class Author < ActiveFedora::Base
  has_metadata :name=>'descMetadata', :type=>KB::Datastream::Mods
  has_metadata :name=>'TEI_P5', :type=>
  delegate :authorName, :to =>''
end