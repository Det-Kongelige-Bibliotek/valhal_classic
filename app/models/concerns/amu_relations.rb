# -*- encoding : utf-8 -*-
module Concerns
  # Handles all relationships between a AuthorityMetadataUnits and Works/Instances, from the AuthorityMetadataUnit perspective.
  module AMURelations
    extend ActiveSupport::Concern

    included do
      #####################################################
      ## Relations to authority metadata units for the non-agent-specific relations
      #####################################################

      # Topic relationships to AuthorityMetadata
      has_and_belongs_to_many :isTopicOf, :class_name => 'ActiveFedora::Base', :property=>:is_topic_of, :inverse_of => :has_topic
      # Geographic relationships to AuthorityMetadata
      has_and_belongs_to_many :isGeographicOf, :class_name => 'ActiveFedora::Base', :property=>:is_geographic_of, :inverse_of => :has_geographic
      # Created relationships to AuthorityMetadata
      has_and_belongs_to_many :isCreatedOf, :class_name => 'ActiveFedora::Base', :property=>:is_created_of, :inverse_of => :has_created
      # Origin relationships to AuthorityMetadata
      has_and_belongs_to_many :isOriginOf, :class_name => 'ActiveFedora::Base', :property=>:is_origin_of, :inverse_of => :has_origin

      #####################################################
      ## Relations to agent authority metadata units.
      #####################################################

      # Addressee relationship from work/instance perspective
      has_and_belongs_to_many :isAddresseeOf, :class_name => 'ActiveFedora::Base', :property=>:is_addressee_of, :inverse_of => :has_addressee
      # Author relationship from work/instance perspective
      has_and_belongs_to_many :isAuthorOf, :class_name => 'ActiveFedora::Base', :property=>:is_author_of, :inverse_of => :has_author
      # Contributor relationship from work/instance perspective
      has_and_belongs_to_many :isContributorOf, :class_name => 'ActiveFedora::Base', :property=>:is_contributor_of, :inverse_of => :has_contributor
      # Creator relationship from work/instance perspective
      has_and_belongs_to_many :isCreatorOf, :class_name => 'ActiveFedora::Base', :property=>:is_creator_of, :inverse_of => :has_creator
      # Owner relationship from work/instance perspective
      has_and_belongs_to_many :isOwnerOf, :class_name => 'ActiveFedora::Base', :property=>:is_owner_of, :inverse_of => :has_owner
      # Patron relationship from work/instance perspective
      has_and_belongs_to_many :isPatronOf, :class_name => 'ActiveFedora::Base', :property=>:is_patron_of, :inverse_of => :has_patron
      # Performer relationship from work/instance perspective
      has_and_belongs_to_many :isPerformerOf, :class_name => 'ActiveFedora::Base', :property=>:is_performer_of, :inverse_of => :has_performer
      # Photographer relationship from work/instance perspective
      has_and_belongs_to_many :isPhotographerOf, :class_name => 'ActiveFedora::Base', :property=>:is_photographer_of, :inverse_of => :has_photographer
      # Printer relationship from work/instance perspective
      has_and_belongs_to_many :isPrinterOf, :class_name => 'ActiveFedora::Base', :property=>:is_printer_of, :inverse_of => :has_printer
      # Publisher relationship from work/instance perspective
      has_and_belongs_to_many :isPublisherOf, :class_name => 'ActiveFedora::Base', :property=>:is_publisher_of, :inverse_of => :has_publisher
      # Scribe relationship from work/instance perspective
      has_and_belongs_to_many :isScribeOf, :class_name => 'ActiveFedora::Base', :property=>:is_scribe_of, :inverse_of => :has_scribe
      # Translator relationship from work/instance perspective
      has_and_belongs_to_many :isTranslatorOf, :class_name => 'ActiveFedora::Base', :property=>:is_translator_of, :inverse_of => :has_translator
    end

    # @return All the relations defined in this module.
    def getRelations
      res = Hash.new
      res['isTopicOf'] = self.isTopicOf
      res['isGeographicOf'] = self.isGeographicOf
      res['isCreatedOf'] = self.isCreatedOf
      res['isOriginOf'] = self.isOriginOf
      res['isAddresseeOf'] = self.isAddresseeOf
      res['isAuthorOf'] = self.isAuthorOf
      res['isContributorOf'] = self.isContributorOf
      res['isCreatorOf'] = self.isCreatorOf
      res['isOwnerOf'] = self.isOwnerOf
      res['isPatronOf'] = self.isPatronOf
      res['isPerformerOf'] = self.isPerformerOf
      res['isPhotographerOf'] = self.isPhotographerOf
      res['isPrinterOf'] = self.isPrinterOf
      res['isPublisherOf'] = self.isPublisherOf
      res['isScribeOf'] = self.isScribeOf
      res['isTranslatorOf'] = self.isTranslatorOf
      res
    end

  end
end
