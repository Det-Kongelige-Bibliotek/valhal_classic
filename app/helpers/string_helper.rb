# -*- encoding : utf-8 -*-

# The helper methods for dealing with Strings.
module StringHelper
  # Removes any special characters (meaning anything but letters, numbers, spaces, comma, dot, dash, slash, underscore).
  # @param s The string to escape the special characters from.
  # @return The string without the special characters.
  def escape_special_characters(s)
    s.gsub(/[^0-9A-Za-zæøåÆØÅ ,.-\/_]/, '')
  end
end
