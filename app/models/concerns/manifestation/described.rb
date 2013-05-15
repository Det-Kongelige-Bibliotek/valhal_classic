# -*- encoding : utf-8 -*-
module Concerns
  module Manifestation
    # handles the describe relationship from the person to the different manifestations
    module Described
      extend ActiveSupport::Concern

      included do
        #A manifestatino can be used to describe a person, e.g. as a AuthorDescrption, biography, etc.
        has_and_belongs_to_many :people_described, :class_name => "Person", :property => :is_description_of, :inverse_of => :has_description
      end

      # Whether any person is described by this manifestation.
      def has_described_person?
        return people_described.any?
      end

      # clears the people_described list.
      # return false if there is no described people in this manifestation,
      # else true
      def clear_described_people
        unless self.people_described.empty?
          self.people_described_ids = []
          true
        end
      end
    end
  end
end