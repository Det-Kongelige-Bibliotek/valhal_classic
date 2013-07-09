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

end