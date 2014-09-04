# Responsible for converting between different standard formats
class ConversionService

  # Given an aleph marc file and a pdf link
  # transform to standard marc and insert link
  # in relevant file
  def self.transform_aleph_to_slim_marc(aleph_marc, pdf_uri)
    doc = Nokogiri::XML.parse(aleph_marc)
    slim_xslt = Nokogiri::XSLT(File.read("#{Rails.root}/xslt/oaimarc2slimmarc.xsl"))
    slim_xslt.transform(doc, Nokogiri::XSLT.quote_params(['pdfUri', pdf_uri]))
  end

  # Given a standard marc xml file
  # transform to mods using LOC stylesheet
  def self.transform_marc_to_mods(marc)
    marc2mods = Nokogiri::XSLT(File.read("#{Rails.root}/xslt/marcToMODS.xsl"))
    marc2mods.transform(marc)
  end

  # Aleph directly to mods
  # @param aleph_marc String
  # @param pdf_uri String
  # @return mods Nokogiri::XML::Document
  def self.aleph_to_mods(aleph_marc, pdf_uri='')
    marc = self.transform_aleph_to_slim_marc(aleph_marc, pdf_uri)
    self.transform_marc_to_mods(marc)
  end
end