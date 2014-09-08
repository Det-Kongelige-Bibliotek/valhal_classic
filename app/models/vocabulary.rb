# This class functions as a wrapper around
# redis-rb and redis-objects to give AR functionality
class Vocabulary < ValhalOhm
  attribute :name
  index :name
  collection :entries, :VocabularyEntry
end

class VocabularyEntry < ValhalOhm
  attribute :name
  attribute :description
  reference :vocabulary, :Vocabulary
end

