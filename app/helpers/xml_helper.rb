# -*- encoding : utf-8 -*-

# The helper methods for dealing with XML.
module XmlHelper
  # Extracts the namespace prefix for a given namespace.
  # E.g. "xmlns:mods"=>"http://www.loc.gov/mods/v3" would give the prefix 'mods'.
  # @oaram
  def self.extract_namespace_prefix(xml, namespace)
    res = xml.namespaces.select {|k,v| v == namespace}.keys.first
    res.partition(':').last unless res.nil?
  end
end