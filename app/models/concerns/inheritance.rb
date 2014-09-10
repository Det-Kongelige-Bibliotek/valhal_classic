module Concerns
  module Inheritance
    extend ActiveSupport::Concern
    
    included do
      def assert_content_model
        super()
        object_superclass = self.class.superclass
        until object_superclass == ActiveFedora::Base || object_superclass == Object do
          add_relationship(:has_model, object_superclass.to_class_uri)
          object_superclass = object_superclass.superclass
        end
      end
    end

  end

end