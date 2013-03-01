# -*- encoding : utf-8 -*-
# This class is intended to be used as a super-class for all instances of intellectual entities.
# An intellectual entity must be identifiable through an UUID. It is possible to create an intellectual entity with a
# specific UUID, but if no UUID is defined during creation, then a randomly generated UUID is assigned.
# The class only contains a 'digiprovMetadata' stream, which then contains the uuid for the given intellectual entity.
class IntellectualEntity < ActiveFedora::Base
  include ActiveFedora::Callbacks
  include ActiveFedora::Validations

  # Digital provenance metadata stream for the intellectual entity.
  has_metadata :name => 'provenanceMetadata', :type => ActiveFedora::SimpleDatastream do |m|
    m.field "uuid", :string
  end

  # Define the uuid as an accessible part of the digitial provenance metadata.
  delegate_to 'provenanceMetadata', [:uuid], :unique => true

  # Validation criteria of the uuid.
  validates :uuid, :presence => true, :length => { :minimum => 16, :maximum => 64}

  # Automatical creation of a random value in the UUID if it has not been defined at the point of saving.
  before_validation(:on => :create) do
    self.uuid = UUID.new.generate unless self.uuid
  end
end
