# -*- encoding : utf-8 -*-
module Concerns
  module WorkWorkRelations
    extend ActiveSupport::Concern

    included do
      has_attributes :nextInSequence, :previousInSequence, datastream: 'descMetadata', multiple: false

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

      # Add relationship to a previous
      # work and set the previous work's
      # next work to the current work
      # @param Work
      def add_previous(work)
        self.save unless self.persisted?
        work.save unless work.persisted?
        # if there is already a previous
        # work, make sure that it is not
        # still pointing to this work
        if self.previousInSequence
          old = previous_work
          old.nextInSequence = nil
          old.save
        end
        self.previousInSequence = work.pid
        work.nextInSequence = self.pid
        save && work.save
      end

      # reverse of add_previous
      # @param Work
      def add_next(work)
        self.save unless self.persisted?
        work.save unless work.persisted?
        # if there is already a next
        # work, make sure that it is not
        # still pointing to this work
        if self.nextInSequence
          old = next_work
          old.previousInSequence = nil
          old.save
        end
        work.previousInSequence = self.pid
        self.nextInSequence = work.pid
        save && work.save
      end
    end

    # Accessor method to return Work
    # object based on a pid stored
    # in previousInSequence
    def previous_work
      Work.find(previousInSequence)
    end

    # Accessor method to return Work
    # object based on a pid stored
    # in previousInSequence
    def next_work
      Work.find(nextInSequence)
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