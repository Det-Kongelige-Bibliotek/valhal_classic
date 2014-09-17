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
  def self.aleph_marc_to_mods(aleph_marc, pdf_uri='')
    marc = self.transform_aleph_to_slim_marc(aleph_marc, pdf_uri)
    self.transform_marc_to_mods(marc)
  end

  # Convert an aleph sysnum to a mods record
  def self.aleph_to_mods(sysnum)
    aleph = AlephService.new
    record = aleph.find_by_sysnum(sysnum)
    raise "Record with sysnum #{sysnum} not found in Aleph" if record.nil?
    ConversionService.aleph_marc_to_mods(record)
  end

  def self.aleph_to_mods_datastream(sysnum)
    mods = ConversionService.aleph_to_mods(sysnum)
    Datastreams::Mods.from_xml(mods)
  end

  # Given an Aleph sysnum
  # Get the marc and convert it
  # to Valhal metadata
  # @param sysnum String
  # @return fields_for_work Hash
  def self.aleph_to_valhal(sysnum)
    mods = ConversionService.aleph_to_mods(sysnum)
    TransformationService.extract_mods_fields_as_hashes(mods)
  end
end