class Vocabulary < ValhalOhm
  attribute :name
  unique :name
  collection :entries, :VocabularyEntry

  # Overwrite super method to enable
  # us to return a boolean rather than
  # an exception on failure
  def save
    begin
      super
    rescue Ohm::UniqueIndexViolation
      errors.add :name, 'Field must be unique!'
      false
    end
  end

  def create
    begin
      super
    rescue Ohm::UniqueIndexViolation
      errors.add :name, 'Field must be unique!'
      false
    end
  end


  def entries=(new_entries)
    self.save unless self.persisted?
    new_entries.each do |new|
      hash = params_to_hash(new)
      if hash.key?(:id) && hash[:id].present?
        entry = VocabularyEntry[hash[:id]]
        hash.merge!(vocabulary_id: self.id)
        entry.update(hash)
      elsif hash.key?(:name) && hash[:name].present?
        entry = VocabularyEntry.new(name: hash[:name], description: hash[:description], vocabulary_id: self.id)
      end
      entry.save if defined?(entry) and entry
    end
    save
  end

  # convert a hash with string keys
  # to one with symbol keys
  def params_to_hash(params)
    symboled = {}
    params.each{ |k,v| symboled[k.to_sym] = v }
    symboled
  end
end