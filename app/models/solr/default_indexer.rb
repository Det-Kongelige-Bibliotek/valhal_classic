module Solr
  class DefaultIndexer
    attr_reader :solr_fields
    def initialize(object)
      @solr_fields = object.class.solr_fields
      @object = object
    end

    def generate_solr_doc
      solr_doc = {}
      @solr_fields.each do |solr_field|
        if @object.respond_to?(solr_field.method_name)
          value = value_from_object(solr_field)
          solr_doc[solr_field.solr_name] = value unless invalid?(value)
        end
      end
      solr_doc
    end

    private
    def invalid?(value)
      if value.respond_to?(:blank?)
        value.blank?
      elsif value.respond_to?(:empty?)
        value.empty?
      else
        value.nil?
      end
    end

    private
    def value_from_object(solr_field)
      value = @object.send(solr_field.method_name)
      if solr_field.value_handler
        value = solr_field.value_handler.call(value)
      end
      value
    end

  end
end


