# -*- encoding : utf-8 -*-
module Concerns
  module Manifestation
    # handles the is_concerned_by relationship from the person to the different manifestations
    module Concerning
      extend ActiveSupport::Concern

      included do
        #A manifestation can concern a person, e.g. as a AuthorDescription, biography, etc.
        has_and_belongs_to_many :people_concerned, :class_name => 'ActiveFedora::Base', :property => :concerning, :inverse_of => :is_concerned_by
      end

      # Whether any person is concerned by this manifestation.
      def has_concerned_person?
        return people_concerned.any?
      end

      # clears the people_concerned list.
      # return false if there is no concerned people in this manifestation,
      # else true
      def clear_concerned_people
        unless self.people_concerned.empty?
          self.people_concerned_ids = []
          true
        end
      end
    end
  end
end