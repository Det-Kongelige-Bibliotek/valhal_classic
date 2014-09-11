class VocabularyEntry < ValhalOhm
  attribute :name
  attribute :description
  reference :vocabulary, :Vocabulary
end