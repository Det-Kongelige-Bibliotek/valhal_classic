# -*- encoding : utf-8 -*-

# Utility helper method containing generic utility methods, which should be usable across different classes, etc.
module UtilityHelper
  # Validates whether an array has any non-empty content.
  # @param array The array to validate
  def contentless_array?(array)
    if(array.nil? || array.empty?)
      return true
    end
    array.each do |id|
      if !id.empty?
        return false
      end
    end
    return true
  end

  #Returns an array of String values, useful for populating drop-down menus
  #@param controlled_vocab_name String name of the controlled vocabulary whose values you want to use
  #@return [Array of Strings]
  def get_controlled_vocab(controlled_vocab_name)
    vocabulary = Vocabulary.with(:name, controlled_vocab_name)
    vocabulary.nil? ? [] : vocabulary.entries.map { |e| e.name }
  end

  #Creates a typeahead dropdown for AuthorityMetadataUnits
  #@param a child class of AuthorityMetadataUnit
  def render_typeahead_dropdown(amu)
    results = amu.get_search_objs
    select_tag "#{amu.to_s.downcase}[id]", options_for_select(results.collect { |result| [result['amu_value_ssi'], result['id']] }),
               include_blank: true, class: 'combobox form-control input-large dropdown-toggle'
  end

end