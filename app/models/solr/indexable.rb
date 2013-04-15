module Solr
  #adds a to_solr method with values from solr_indexer
  #depends on the model having given a indexer to solr_indexer and having the class.solr_fields method
  module Indexable
    extend ActiveSupport::Concern

    included do
      attr_reader :solr_indexer

      after_initialize :init_indexer

      def init_indexer
        @solr_indexer = Solr::DefaultIndexer.new(self)
      end
    end

    def to_solr(solr_doc = {})
      super
      solr_doc.merge!(solr_doc_from_indexer) unless solr_doc_from_indexer.nil?
      solr_doc
    end

    private
    def solr_doc_from_indexer
      indexer = self.solr_indexer
      indexer.generate_solr_doc unless indexer.nil?
    end

    module ClassMethods

      #returns a hash with value names as key and solr_name as value
      #depends on class.solr_fields method
      def solr_names
        solr_names = {}
        solr_fields.each do |solr_field|
          solr_names[solr_field.name.to_sym] = solr_field.solr_name
        end
        solr_names
      end

      def has_solr_fields
        if block_given?
          yield self
        end
      end

      def field(name, options = {}, &block)
        @@solr_fields ||= []
        @@solr_fields << SolrField.create(name, options, &block) unless name.blank?
      end

      def solr_fields
        @@solr_fields
      end

    end
  end
end
