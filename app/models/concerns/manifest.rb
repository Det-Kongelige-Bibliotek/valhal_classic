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
