# -*- encoding : utf-8 -*-
class Entity < ActiveFedora::Base

  has_metadata :name => 'descMetadata', :type => Datastreams::WorkDescMetadata

  # List of non-multiple key-value pairs
  has_attributes :title, :subTitle,
                 datastream: 'descMetadata', :multiple => false

  # List of multiple key-value pairs
  has_attributes :genre, :identifier, :topic, :note,
                 datastream: 'descMetadata', :multiple => true

  def alternativeTitle(*arg)
    self.descMetadata.get_alternative_title
  end

  def alternativeTitle=(val)
    self.descMetadata.remove_alternative_title
    val.each do |v|
      self.descMetadata.insert_alternative_title(v) unless v['title'].blank?
    end
  end

end