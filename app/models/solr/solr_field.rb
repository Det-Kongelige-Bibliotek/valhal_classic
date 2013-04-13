module Solr
  class SolrField
    attr_reader :name, :solr_name, :method_name, :value_handler

    def initialize(name, solr_name, method_name, value_handler)
      @name = name
      @solr_name = solr_name
      @method_name = method_name
      @value_handler = value_handler
    end

    def self.create(name, opts = {}, &block)
      solr_name = ActiveFedora::SolrService.solr_name(name, solr_descriptor(opts))
      meth_name = method_name(name, opts)
      val_handler = block_to_proc(&block)
      SolrField.new(name, solr_name, meth_name, val_handler)
    end

    private
    def self.solr_descriptor(opts)
      if opts[:index_as]
        solr_index_options = opts[:index_as]
      else
        solr_index_options = [:text, :stored, :indexed]
      end
      Solrizer::Descriptor.new(*solr_index_options)
    end

    private
    def self.method_name(name, opts)
      if opts[:method]
        opts[:method]
      else
        name.to_sym
      end
    end

    private
    def self.block_to_proc(&block)
      if block_given?
        Proc.new(&block)
      end
    end
  end
end
