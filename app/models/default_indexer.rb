class DefaultIndexer
  def initialize(klazz = nil)
    @solr_fields = {}
    @klazz = klazz
  end

  def add_field(name, type)
    @solr_fields[name.to_sym] = ActiveFedora::SolrService.solr_name(name, Solrizer::Descriptor.new(type, :stored, :indexed))
  end

  def generate_solr_doc
    solr_doc = {}
    @solr_fields.each do |name, solr_name|
      if @klazz.respond_to?(name)
        value = @klazz.send(name)
        solr_doc[solr_name] = value unless value.blank?
      end
    end
    solr_doc

  end

  #returns the solr_name value if this instance is called with a name that is in solr_fields
  #exsample when a field named author have been added on indexer:
  #indexer.author => author_ssi
  def method_missing(sym, *args, &block)
    if @solr_fields[sym]
      @solr_fields[sym]
    else
      super
    end
  end
end

