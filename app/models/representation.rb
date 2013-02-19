# -*- encoding : utf-8 -*-
# This class is intended to be used as a super-class for all representations.
# The representations must have a label.
class Representation < ActiveFedora::Base

  # Descriptive metadata for the label
  has_metadata :name => 'provenanceMetadata', :type => ActiveFedora::SimpleDatastream do |m|
    m.field "label", :string
  end

  # Define the label as an accessible part of the descriptive metadata.
  delegate_to 'provenanceMetadata', [:label], :unique => true

  # Automatical creation of a the label if it has not been defined.
  before_validation(:on => :create) do
    self.label = self.class.name.to_s unless label
  end
end
