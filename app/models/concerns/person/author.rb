# -*- encoding : utf-8 -*-
module Concerns
  module Person
    # handles the author relationship from the person to the different manifestations
    module Author
      extend ActiveSupport::Concern

      included do
        # Author relationship to manifestations.
        has_and_belongs_to_many :authored_manifestations, :class_name => 'ActiveFedora::Base', :property => :is_author_of, :inverse_of => :has_author
      end

      # extract the manifestations of the type work.
      def authored_works
        res = []
        authored_manifestations.each do |man|
          if man.kind_of? Work
            res << man
          end
        end
        return res
      end

      # Determines whether any work has been authored by this person.
      def is_author_of_work?
        authored_works.any?
      end
    end
  end
end