module Concerns
  module Representation
    extend ActiveSupport::Concern

    included do
      # Descriptive metadata for the label
      has_metadata :name => 'provenanceMetadata', :type => ActiveFedora::SimpleDatastream do |m|
        m.field "label", :string
      end

      # Define the label as an accessinbn ble part of the descriptive metadata.
      delegate :label, :to=> 'provenanceMetadata', :at => [:label], :unique => true

      # Automatical creation of a the label if it has not been defined.
      before_validation(:on => :create) do
        self.label =  self.class.name.to_s if self.label.blank?
      end

      def has_ie?
        !self.ie.nil?
      end

      def method_missing(method, *args)
        methods = [:book, :book=, :person, :person=, :work, :work=]
        if methods.include?(method)
          read_or_set_ie *args
        else
          super
        end
      end

      private
      def read_or_set_ie(*args)
        if args.empty?
          self.send :ie
        else
          self.send :ie=, *args
        end
      end
    end

  end

end
