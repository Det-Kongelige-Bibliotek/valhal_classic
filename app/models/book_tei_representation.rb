# -*- encoding : utf-8 -*-
class BookTeiRepresentation < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream do |m|
    m.field "tei_version", :string
  end

  has_metadata :name => 'provMetadata', :type => ActiveFedora::SimpleDatastream

  delegate_to 'descMetadata', [:tei_version], :unique => true

  has_many :files, :class_name => 'BasicFile', :property => :is_part_of
  belongs_to :book, :property => :is_part_of
end
