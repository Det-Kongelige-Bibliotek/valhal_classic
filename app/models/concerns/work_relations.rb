# -*- encoding : utf-8 -*-
module Concerns
  # Handles all relationships between a Work and authority-metadata-units, from the Works perspective.
  module WorkRelations
    extend ActiveSupport::Concern

    included do
      #####################################################
      ## Relations to authority metadata units for the non-agent-specific relations
      #####################################################

      # Topic relationships to AuthorityMetadata
      has_and_belongs_to_many :hasTopic, :class_name => 'ActiveFedora::Base', :property=>:has_topic, :inverse_of => :is_topic_of
      # Geographic relationships to AuthorityMetadata
      has_and_belongs_to_many :hasGeographic, :class_name => 'ActiveFedora::Base', :property=>:has_geographic, :inverse_of => :is_geographic_of
      # Created relationships to AuthorityMetadata
      has_and_belongs_to_many :hasCreated, :class_name => 'ActiveFedora::Base', :property=>:has_created, :inverse_of => :is_created_of
      # Origin relationships to AuthorityMetadata
      has_and_belongs_to_many :hasOrigin, :class_name => 'ActiveFedora::Base', :property=>:has_origin, :inverse_of => :is_origin_of

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
      has_and_belongs_to_many :hasDigitizer, :class_name => 'ActiveFedora::Base', :property=>:has_translator, :inverse_of => :is_digitizer_of

    end

    # @return All the relations defined in this module.
    def getRelations
      res = Hash.new
      res['hasTopic'] = self.hasTopic
      res['hasGeographic'] = self.hasGeographic
      res['hasCreated'] = self.hasCreated
      res['hasOrigin'] = self.hasOrigin
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
