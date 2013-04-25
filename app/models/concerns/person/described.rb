# -*- encoding : utf-8 -*-
module Concerns
  module Person
    # handles the describe relationship from the person to the different manifestations
    module Described
      extend ActiveSupport::Concern

      included do
        # A person can be described by more than one manifestation, and a manifestation can describe more than one person
        has_and_belongs_to_many :describing_manifestations, :class_name => 'ActiveFedora::Base', :property => :has_description, :inverse_of => :is_description_of
      end

      # extract the manifestations of the type book.
      def describing_books
        res = []
        describing_manifestations.each do |man|
          if man.kind_of? Book
            res << man
          end
        end
        return res
      end

      # extract the manifestations of the type book.
      def describing_works
        res = []
        describing_manifestations.each do |man|
          if man.kind_of? Work
            res << man
          end
        end
        return res
      end

      # Determines whether any book describes this person.
      def is_described_by_book?
        describing_books.any?
      end

      # Determines whether any work describes this person.
      def is_described_by_work?
        describing_works.any?
      end
    end
  end
end