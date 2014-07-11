# -*- encoding : utf-8 -*-
module Concerns
  module Instance
    extend ActiveSupport::Concern

    included do
      include IntellectualEntity
      include Concerns::InstanceMetadata

      # relationships that all instances must have
      # belongs_to ie(short for IntellectualEntity), can be a Book, Person and so on
      # has_many basic_files, can be BasicFile, TiffFile and so on
      has_many :files, :class_name => 'ActiveFedora::Base', :property => :is_part_of, :inverse_of => :has_part
      belongs_to :ie, :class_name => 'ActiveFedora::Base', :property => :has_representation, :inverse_of => :is_representation_of

      # adds the instance to the basic_files container after a save so we dont have to manage all that saving before adding
      # example
      # Before:
      # rep = SingleFileInstance.new(params[:rep])
      # rep.save!
      # rep_file = BasicFile.new
      # rep_file.add_file(params[:basic_files][:basic_files])
      # rep_file.container = rep
      # rep_file.save!
      # rep.basic_files << rep_file
      #
      # rep.work = @work
      # rep.save!
      #
      # After:
      # rep = SingleFileInstance.new(params[:rep])
      #
      # rep_file = BasicFile.new
      # rep_file.add_file(params[:basic_files][:basic_files])
      # rep.basic_files << rep_file
      #
      # @work.instances << rep
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

      # @return Whether any intellectual entity for this instance has been defined.
      def has_ie?
        !self.ie.nil?
      end

      private
    end

    # @return The name of the instance (default the label)
    def instance_name
      uuid
    end

    # @return whether its preservation can be inherited. For the instances, this is true (since it has the files).
    def preservation_inheritance?
      return true
    end

    # Returns all the files as BasicFile objects.
    # @return the object, which can inherit the preservation settings.
    def preservation_inheritable_objects
      res = []
      self.files.each do |f|
        res << BasicFile.find(f.pid)
      end
      logger.debug "Found following inheiritable objects: #{res.to_s}"
      res
    end
  end

end
