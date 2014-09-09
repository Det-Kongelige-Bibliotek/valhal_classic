class Vocabulary < ValhalOhm
  attribute :name
  index :name
  collection :entries, :VocabularyEntry

  def entries=(new_entries)
    self.save unless self.persisted?
    new_entries.each do |new|
      hash = params_to_hash(new)
      if hash.key?(:id) && hash[:id].present?
        entry = VocabularyEntry[hash[:id]]
        hash.merge!(vocabulary_id: self.id)
        entry.update(hash)
      else
        entry = VocabularyEntry.new(name: hash[:name], description: hash[:description], vocabulary_id: self.id)
      end
      entry.save
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