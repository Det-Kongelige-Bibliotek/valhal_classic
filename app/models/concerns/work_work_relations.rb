# -*- encoding : utf-8 -*-
module Concerns
  module WorkWorkRelations
    extend ActiveSupport::Concern

    included do
      has_many :nextInSequence, :class_name => 'ActiveFedora::Base', :property=>:next_in_sequence, :inverse_of => :previous_in_sequence
      belongs_to :previousInSequence, :class_name => 'ActiveFedora::Base', :property=>:previous_in_sequence, :inverse_of => :next_in_sequence
      has_many :parts, :class_name => 'Work', property: :has_parts, inverse_of: :is_part_of
      belongs_to :is_part_of, :class_name => 'Work', property: :is_part_of, inverse_of: :parts

      # we need this to update work-to-work relations via the view
      alias isPartOf= is_part_of=

      # We're intercepting the standard
      # accessor here so that it can
      # handle single objects
      def next_in_sequence=(obj)
        if obj.class == Array
          add_next(obj.first)
        else
          add_next(obj)
        end
      end
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

      # Add relationship to a previous
      # work and set the previous work's
      # next work to the current work
      # @param Work
      def add_previous(work)
        self.save unless self.persisted?
        work.save unless work.persisted?
        self.previousInSequence = work
        work.nextInSequence = [self]
      end

      # reverse of add_previous
      # @param Work
      def add_next(work)
        self.save unless self.persisted?
        work.save unless work.persisted?
        work.previousInSequence = self
        self.save
        self.nextInSequence = [work]
        work.save
      end
    end


    def get_work_relations
      rels = {}
      rels[:next_in_sequence] = self.nextInSequence.last
      rels[:previousInSequence] = self.previousInSequence
      rels[:hasParts] = self.parts
      rels[:isPartOf] = self.is_part_of
      rels
    end
  end
end