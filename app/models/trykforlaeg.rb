class Trykforlaeg < OrderedInstance
  include Concerns::Instance
  include ActiveRecord::Validations

  has_metadata :name => 'descMetadata', :type => Datastreams::InstanceDescMetadata
  has_attributes :isbn, datastream: 'descMetadata', multiple: false

  validates :isbn, :presence => true
  validates :isbn, :isbn_format => true
end