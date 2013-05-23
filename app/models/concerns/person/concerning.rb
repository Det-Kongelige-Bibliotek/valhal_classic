# -*- encoding : utf-8 -*-
module Concerns
  module Person
    # handles the is_concerned_by relationship from the person to the different manifestations
    module Concerning
      extend ActiveSupport::Concern

      included do
        # A person can be concerned by more than one manifestation, and a manifestation can describe more than one person
        has_and_belongs_to_many :concerning_manifestations, :class_name => 'ActiveFedora::Base', :property => :is_concerned_by, :inverse_of => :concerning
      end

      # extract the manifestations of the type book.
      def concerning_books
        res = []
        concerning_manifestations.each do |man|
          if man.kind_of? Book
            res << man
          end
        end
        res
      end

      # extract the manifestations of the type book.
      def concerning_works
        res = []
        concerning_manifestations.each do |man|
          if man.kind_of? Work
            res << man
          end
        end
        res
      end

      # Determines whether any book concerns this person.
      def is_concerned_by_book?
        concerning_books.any?
      end

      # Determines whether any work concerns this person.
      def is_concerned_by_work?
        concerning_works.any?
      end
    end
  end
end