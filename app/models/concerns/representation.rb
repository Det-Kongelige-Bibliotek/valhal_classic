module Concerns
  module Representation
    extend ActiveSupport::Concern

    included do
      # Descriptive metadata for the label
      has_metadata :name => 'provenanceMetadata', :type => ActiveFedora::SimpleDatastream do |m|
        m.field "label", :string
      end

      # Define the label as an accessinbn ble part of the descriptive metadata.
      delegate :label, :to => 'provenanceMetadata', :at => [:label], :unique => true

      # Automatical creation of a the label if it has not been defined.
      before_validation(:on => :create) do
        self.label = self.class.name.to_s if self.label.blank?
      end

      # relationships that all representations must have
      # belongs_to ie(short for IntellectualEntity), can be a Book, Person and so on
      # has_many files, can be BasicFile, TiffFile and so on
      has_many :files, :class_name => 'ActiveFedora::Base', :property => :is_part_of, :inverse_of => :has_part
      belongs_to :ie, :class_name => 'ActiveFedora::Base', :property => :has_representation, :inverse_of => :is_representation_of

      # adds the representation to the file container after a save so we dont have to manage all that saving before adding
      # example
      # Before:
      # rep = SingleFileRepresentation.new(params[:rep])
      # rep.save!
      # rep_file = BasicFile.new
      # rep_file.add_file(params[:file][:file])
      # rep_file.container = rep
      # rep_file.save!
      # rep.files << rep_file
      #
      # rep.work = @work
      # rep.save!
      #
      # After:
      # rep = SingleFileRepresentation.new(params[:rep])
      #
      # rep_file = BasicFile.new
      # rep_file.add_file(params[:file][:file])
      # rep.files << rep_file
      #
      # @work.representations << rep
      # @work.save
      after_save :add_representation_to_files


      def add_representation_to_files
        if self.files
          self.files.each do |file|
            if file.container.nil?
              file.container = self
              file.save
            end
          end
        end
      end


      def has_ie?
        !self.ie.nil?
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

    # class variable for holding methods symbols
    @@methods = [:book, :book=, :person, :person=, :work, :work=]

    def method_missing(method, *args)

      if @@methods.include?(method)
        read_or_set_ie *args
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @@methods.include?(method_name) || super
    end

  end

end
