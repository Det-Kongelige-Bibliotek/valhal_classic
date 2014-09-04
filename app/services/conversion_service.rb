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

  # Given an Aleph sysnum
  # Get the marc and convert it
  # to Valhal Work attributes
  # @param sysnum String
  # @return fields_for_work Hash
  def self.aleph_to_valhal(sysnum)
    aleph = AlephService.new
    record = aleph.find_by_sysnum(sysnum)
    mods = ConversionService.aleph_to_mods(record)
    fields_for_work, fields_for_instance, metadata_objects = TransformationService.extract_mods_fields_as_hashes(mods)
    fields_for_work
  end
end