# Monkey patch Ohm::Set to ensure
# we have this standard functionality
class Ohm::Set
  alias_method :length, :size
end

# We base our OHM / Redis models on
# this class to enable sharing of
# useful helpers
class ValhalOhm < Ohm::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def self.delete_all
    size = self.all.size
    self.all.each {|v| v.delete}
    size
  end

  def self.count
    self.all.size
  end

  def self.first
    self.all.first
  end

  # ActiveModel compliance
  def self.last
    self.all.last
  end

  def persisted?
    self.id ? true : false
  end

  # ActiveModel compliance
  def id
    begin
      super
    rescue Ohm::MissingID
      nil
    end
  end

  def to_hash
    { id: id }.merge(attributes)
  end

  # useful for tests
  # send params the way we would
  # expect from a form
  def to_params
    stringified = {}
    attributes.each {|k,v| stringified[k.to_s] = v}
    { 'id' => id.to_i }.merge(stringified)
  end

end