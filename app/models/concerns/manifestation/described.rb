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
    end
  end
end