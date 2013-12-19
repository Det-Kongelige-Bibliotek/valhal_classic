# -*- encoding : utf-8 -*-
module Concerns
  # The common manifest for containing representations
  # provides both the representation relationships and relevant methods.
  module Manifest
    extend ActiveSupport::Concern

    included do
      include Concerns::IntellectualEntity

      # A work can have many representations
      has_many :representations, :class_name => 'ActiveFedora::Base', :property=>:is_representation_of, :inverse_of => :has_representation
    end

    # @return Whether any representations for the manifest exists.
    def has_rep?
      return representations.any?
    end

    # @return all ordered representations.
    def ordered_reps
      res = []
      representations.each do |rep|
        if rep.kind_of? OrderedRepresentation
          res << rep
        end
      end

      res
    end

    # @return all single file representations
    def single_file_reps
      res = []
      representations.each do |rep|
        if rep.kind_of? SingleFileRepresentation
          res << rep
        end
      end

      res
    end

    # @return whether its preservation can be inherited.
    # For the manifests, this is true (since it has the representations).
    def preservation_inheritance?
      return true
    end

    # @return the list of objects, which can inherit the preservation settings (only one level)
    def preservation_inheritable_objects
      representations
    end

    # Retrieves a formatted relation to the people and the representations of the manifest.
    # @return The specific metadata for the manifest.
    def get_specific_metadata_for_preservation
      res = ''
      representations.each do |rep|
        res += '<representation>'
        res += "<name>#{rep.representation_name}</name>"
        res += "<uuid>#{rep.uuid}</uuid>"
        res += '</representation>'
      end
      authors.each do |p|
        res += '<author>'
        res += "<name>#{p.comma_separated_lastname_firstname}</name>"
        res += "<uuid>#{p.uuid}</uuid>"
        res += '</author>'
      end
      people_concerned.each do |p|
        res += '<related_person>'
        res += "<name>#{p.comma_separated_lastname_firstname}</name>"
        res += "<uuid>#{p.uuid}</uuid>"
        res += '</related_person>'
      end
      res
    end

    private
    # adds the manifest as intellectual entity for the representations.
    def add_ie_to_reps
      add_ie_to_rep representations
    end

    # go through the given representation array and add itself as intellectual entity for the given representation for each of them.
    # @param rep_array The array of representations to add the intellectual entity for.
    def add_ie_to_rep(rep_array)
      if rep_array
        rep_array.each do |rep|
          if rep.ie.nil?
            rep.ie = self
            rep.save
          end
        end
      end
    end
  end
end
