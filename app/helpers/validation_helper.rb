module ValidationHelper
  # escape quotation marks to prevent solr errors
  def escape_bad_chars(text)
    text.gsub('"', '\"') if text.is_a? String
  end
end