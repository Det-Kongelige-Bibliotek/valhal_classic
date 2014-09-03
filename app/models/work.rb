# -*- encoding : utf-8 -*-
class Work < ActiveFedora::Base
  include Concerns::Manifest
  include Concerns::Preservation
  include Concerns::WorkMetadata
  include Solr::Indexable

  has_metadata :name => 'rightsMetadata', :type => Hydra::Datastream::RightsMetadata

  validates_with WorkValidator

  has_solr_fields do |m|
    m.field "search_result_work_type", method: :workType, :index_as => [:string, :indexed, :stored]
    m.field "title", method: :title
    m.field "sub_title", method: :subTitle
    m.field "type_of_resource", method: :typeOfResource
    m.field "search_result_title", method: :get_title_for_display
    m.field "work_type", method: :workType
    m.field 'preservation_profile', method: :preservation_profile
    m.field 'preservation_state', method: :preservation_state
    m.field 'preservation_details', method: :preservation_details
  end

  def initialize(*args)
    super(*args)
    add_accessors
  end

  # create accessor methods for identifiers
  # e.g. given an identifier
  # { 'displayLabel' => 'sysnum', 'value' => '1234' }
  # create a method sysnum that returns '1234'
  def add_accessors
    if defined? identifier
      identifier.each do |id|
        if id['displayLabel'] && !id['displayLabel'].empty?
          self.class.send(:define_method, id['displayLabel']) { return id['value'] }
        end
      end
    end
  end

  # Delivers the title and subtitle in a format for displaying.
  # Should only include the subtitle, if it has been defined.
  def get_title_for_display
    if title.empty? && workType == 'Letter'
      letter_display_title
    elsif subTitle == nil || subTitle.empty?
      title
    else
      title + ", " + subTitle
    end
  end

  # Return a hash of all ordered instances
  # that have a contentType attr in the form
  # { pdfs: OrderedInstance, jpgs: OrderedInstance }
  def ordered_instance_types
    type_hash = {}
    ordered_instances.each do |i|
      type_hash.store(i.contentType.pluralize.downcase.to_sym, i) unless i.contentType.nil?
    end
    type_hash
  end

  # For each identifier, create a solr search field with name
  # based on that identifier's displayLabel and value of that identifier's value
  # e.g. {displayLabel: 'aleph', value: '1234'} should create a field
  # {"aleph_si"=>"1234", "aleph_ssm"=>["1234"]}
  def to_solr(solr_doc = {})
    super
    identifier.each do |id|
      if id['displayLabel'] && !id['displayLabel'].empty?
        Solrizer.insert_field(solr_doc, id['displayLabel'], id['value'], :sortable, :displayable)
      end
    end
    solr_doc
  end
  after_save :add_to_instances

  # Adds a instance to a work
  # Use this method instead of directly
  # accessing work.instances as the details
  # and order are quite tricky and can lead
  # to confusing errors.
  # @param instance The instance to be added to the work
  def add_instance(instance)
    self.save unless self.pid
    instance.ie = self
    self.instances << instance
    instance.save && self.save
  end

  # Create a suitable translateable display title for letter works
  def letter_display_title
    I18n.t(:letter_title, author: ((self.hasAuthor.blank? || self.hasAuthor.first.blank?) ? '' : self.hasAuthor.first.value),
           addressee: ((self.hasAddressee.blank? || self.hasAddresse.first.blank?)? '': self.hasAddressee.first.value), date: self.dateCreated)
  end

end
