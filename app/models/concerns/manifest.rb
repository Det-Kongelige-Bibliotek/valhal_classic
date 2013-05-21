# -*- encoding : utf-8 -*-
module Concerns
  # The common manifest for containing representations
  # provides both the representation relationships and relevant methods.
  module Manifest

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
      representations.all.each do |rep|
        if rep.kind_of? OrderedRepresentation
          res << rep
        end
      end

      res
    end

    # @return all single file representations
    def single_file_reps
      res = []
      representations.all.each do |rep|
        if rep.kind_of? SingleFileRepresentation
          res << rep
        end
      end

      res
    end
  end
end
