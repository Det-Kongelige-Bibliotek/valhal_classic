class Trykforlaeg < OrderedInstance
  include Concerns::Instance
  include ActiveRecord::Validations

  has_metadata :name => 'descMetadata', :type => Datastreams::InstanceDescMetadata
  has_attributes :isbn, datastream: 'descMetadata', multiple: false

  validates :isbn, :presence => true
  validates :isbn, :isbn_format => true

  validates :dateIssued, :presence => true
  validate :date_issued_is_valid_edtf

  private
  def date_issued_is_valid_edtf
    if (EDTF.parse self.dateIssued).nil?
      errors.add(:dateIssued, 'date issued is an invalid EDTF format')
    end
  end
end