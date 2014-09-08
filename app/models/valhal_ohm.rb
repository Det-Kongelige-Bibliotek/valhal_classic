# We base our OHM / Redis models on
# this class to enable sharing of
# useful helpers
class ValhalOhm < Ohm::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def self.count
    self.all.size
  end

  def persisted?
    self.id ? true : false
  end

  def id
    begin
      super
    rescue Ohm::MissingID
      nil
    end
  end

end