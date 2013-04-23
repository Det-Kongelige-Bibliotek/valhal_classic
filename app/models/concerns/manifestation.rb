# -*- encoding : utf-8 -*-
module Concerns
  # handles the relationship to the person from both the work and book manifestations
  module Manifestation
    extend ActiveSupport::Concern

    included do
      # A manifestation can be authored by more than one person, and a person can author more than one book.
      has_and_belongs_to_many :authors, :class_name => "Person", :property => :has_author, :inverse_of => :is_author_of

      # Whether any author for this book has been defined.
      def has_author?
        return authors.any?
      end

      # clears the author list.
      # TODO: Is this used, and will does it work properly...
      def clear_authors
        authors.clear
      end

      #A manifestatino can be used to describe a person, e.g. as a AuthorDescrption, biography, etc.
      has_and_belongs_to_many :people_described, :class_name => "Person", :property => :is_description_of, :inverse_of => :has_description

      # Whether any person is described by this manifestation.
      def has_described_person?
        return people_described.any?
      end
    end
  end
end