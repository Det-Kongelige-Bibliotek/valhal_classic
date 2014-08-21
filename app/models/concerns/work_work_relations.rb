# -*- encoding : utf-8 -*-
module Concerns
  module WorkWorkRelations
    extend ActiveSupport::Concern

    included do
      has_many :nextInSequence, :class_name => 'ActiveFedora::Base', :property=>:next_in_sequence, :inverse_of => :previous_in_sequence
      belongs_to :previousInSequence, :class_name => 'ActiveFedora::Base', :property=>:previous_in_sequence, :inverse_of => :next_in_sequence
      has_many :parts, :class_name => 'Work', property: :has_parts, inverse_of: :is_part_of
      belongs_to :is_part_of, :class_name => 'Work', property: :is_part_of, inverse_of: :parts


      # Add part and ensure relationship
      # is defined on both elements.
      # @param Work
      # @return Boolean
      def add_part(part)
        self.parts << part
        part.save unless part.pid
        part.is_part_of = self
        self.save
      end
    end

  end
end