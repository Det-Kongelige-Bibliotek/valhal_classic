# -*- encoding : utf-8 -*-
module Concerns
  module Manifestation
    # handles the author relationship from the person to the different manifestations
    module Author
      extend ActiveSupport::Concern

      included do
        # A manifestation can be authored by more than one person, and a person can author more than one book.
        has_and_belongs_to_many :authors, :class_name => 'ActiveFedora::Base', :property => :has_author, :inverse_of => :is_author_of
      end

      # Whether any author for this book has been defined.
      def has_author?
        return authors.any?
      end

      # clears the author list.
      # return false if there is no authors in this manifestation,
      # else true
      def clear_authors
        unless self.authors.empty?
          self.author_ids = []
          true
        end
      end
    end
  end
end