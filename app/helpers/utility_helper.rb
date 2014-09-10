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
    Vocabulary.with(:name, controlled_vocab_name).entries.map {|e| e.name}
  end

end