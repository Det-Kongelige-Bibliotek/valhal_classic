require 'datastreams/adl_tei_p5'
require 'datastreams/mods'

class Author < ActiveFedora::Base
  #Dummy fields that I needed to display the create new author view, must be replaced by real model
  attr_accessor :life, :name, :quote, :time_line, :external, :tei_xml, :picture, :time_line_year, :time_line_description, :quote_source
  has_metadata :name => 'descMetadata', :type => KB::Datastream::Mods
  has_metadata :name => 'TEI_P5', :type => KB::Datastream::AdlTeiP5

end