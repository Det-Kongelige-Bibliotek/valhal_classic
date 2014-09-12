# -*- encoding : utf-8 -*-
module Concerns
  # Handles all relationships between authority-metadata-units and Work/Instance, from the perspective of the Work/Instance.
  # These are all the relations possible for both Work and Instance, though some of these are only possible for Work,
  # and some are only possible for Instance, whereas others are possible for both.
  module WorkInstanceRelations
    extend ActiveSupport::Concern

    included do
      #####################################################
      ## Relations to authority metadata units for the non-agent-specific relations
      #####################################################

      # Topic relationships from work/instance perspective  (includes the Agent->topic relation)
      has_and_belongs_to_many :hasTopic, :class_name => 'ActiveFedora::Base', :property=>:has_topic, :inverse_of => :is_topic_of
      # Created relationships from work/instance perspective
      has_and_belongs_to_many :hasCreated, :class_name => 'ActiveFedora::Base', :property=>:has_created, :inverse_of => :is_created_of
      # Origin relationships from work/instance perspective
      has_and_belongs_to_many :hasOrigin, :class_name => 'ActiveFedora::Base', :property=>:has_origin, :inverse_of => :is_origin_of
      # Destination relationships from work/instance perspective
      has_and_belongs_to_many :hasDestination, :class_name => 'ActiveFedora::Base', :property=>:has_destination, :inverse_of => :is_destination_of

      #####################################################
      ## Relations to agent authority metadata units.
      #####################################################

      # Addressee relationship from work/instance perspective
      has_and_belongs_to_many :hasAddressee, :class_name => 'ActiveFedora::Base', :property=>:has_addressee, :inverse_of => :is_addressee_of
      # Author relationship from work/instance perspective
      has_and_belongs_to_many :hasAuthor, :class_name => 'ActiveFedora::Base', :property=>:has_author, :inverse_of => :is_author_of
      # Contributor relationship from work/instance perspective
      has_and_belongs_to_many :hasContributor, :class_name => 'ActiveFedora::Base', :property=>:has_contributor, :inverse_of => :is_contributor_of
      # Creator relationship from work/instance perspective
      has_and_belongs_to_many :hasCreator, :class_name => 'ActiveFedora::Base', :property=>:has_creator, :inverse_of => :is_creator_of
      # Owner relationship from work/instance perspective
      has_and_belongs_to_many :hasOwner, :class_name => 'ActiveFedora::Base', :property=>:has_owner, :inverse_of => :is_owner_of
      # Patron relationship from work/instance perspective
      has_and_belongs_to_many :hasPatron, :class_name => 'ActiveFedora::Base', :property=>:has_patron, :inverse_of => :is_patron_of
      # Performer relationship from work/instance perspective
      has_and_belongs_to_many :hasPerformer, :class_name => 'ActiveFedora::Base', :property=>:has_performer, :inverse_of => :is_performer_of
      # Photographer relationship from work/instance perspective
      has_and_belongs_to_many :hasPhotographer, :class_name => 'ActiveFedora::Base', :property=>:has_photographer, :inverse_of => :is_photographer_of
      # Printer relationship from work/instance perspective
      has_and_belongs_to_many :hasPrinter, :class_name => 'ActiveFedora::Base', :property=>:has_printer, :inverse_of => :is_printer_of
      # Publisher relationship from work/instance perspective
      has_and_belongs_to_many :hasPublisher, :class_name => 'ActiveFedora::Base', :property=>:has_publisher, :inverse_of => :is_publisher_of
      # Scribe relationship from work/instance perspective
      has_and_belongs_to_many :hasScribe, :class_name => 'ActiveFedora::Base', :property=>:has_scribe, :inverse_of => :is_scribe_of
      # Translator relationship from work/instance perspective
      has_and_belongs_to_many :hasTranslator, :class_name => 'ActiveFedora::Base', :property=>:has_translator, :inverse_of => :is_translator_of
      # Digitizer relationship from work/instance perspective
      has_and_belongs_to_many :hasDigitizer, :class_name => 'ActiveFedora::Base', :property=>:has_digitizer, :inverse_of => :is_digitizer_of
    end

    # @return All the relations defined in this module.
    def get_all_relations
      res = Hash.new
      res['hasTopic'] = self.hasTopic
      res['hasCreated'] = self.hasCreated
      res['hasOrigin'] = self.hasOrigin
      res['hasDestination'] = self.hasDestination
      res['hasAddressee'] = self.hasAddressee
      res['hasAuthor'] = self.hasAuthor
      res['hasContributor'] = self.hasContributor
      res['hasCreator'] = self.hasCreator
      res['hasOwner'] = self.hasOwner
      res['hasPatron'] = self.hasPatron
      res['hasPerformer'] = self.hasPerformer
      res['hasPhotographer'] = self.hasPhotographer
      res['hasPrinter'] = self.hasPrinter
      res['hasPublisher'] = self.hasPublisher
      res['hasScribe'] = self.hasScribe
      res['hasTranslator'] = self.hasTranslator
      res['hasDigitizer'] = self.hasDigitizer
      res
    end
  end
end
