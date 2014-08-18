class LetterVolumeIngest

  @queue = :letter_volume_ingest
  
  def self.perform(xml_path, pdf_path, jpg_path)
    pdf_file = LetterVolumeFile.new(pdf_path)
    xml_file = LetterVolumeFile.new(xml_path)

    unless pdf_file.sysnum == xml_file.sysnum
      raise 'File names do not match!'
    end
    # Check to see if book exists
    work = self.find_or_create_work(pdf_file.sysnum)

    # Check to see if book has an ordered instance
    content_types = work.ordered_instance_types
    pdfs = content_types[:pdfs] || OrderedInstance.new
    xmls = content_types[:teis] || OrderedInstance.new
    # Add representation to work
    bf_pdf = BasicFile.new
    bf_xml = BasicFile.new
    pdf_added = bf_pdf.add_file(File.new(pdf_path), true)
    pdfs.files.insert(pdf_file.index, bf_pdf)

    xml_added = bf_xml.add_file(File.new(xml_path), true)
    xmls.files.insert(xml_file.index, bf_xml)
    work.ordered_instances << pdfs << xmls
    work_saved = work.save

    unless pdf_added && xml_added && work_saved
      raise 'Could not save to Fedora!'
    end
    # Queue Letter splitter job

  end

  def self.parse_sysnum(path_string)
    file_name = Pathname.new(path_string).basename.to_s
    if file_name.include?('_')
      file_name.split('_').first
    else
      raise "invalid filename given: #{file_name}"
    end
  end

  def self.find_or_create_work(sysnum)
    existing = Work.find('sysnum_si' => sysnum)
    if existing.size > 0
      w = existing.first
    else
      w = Work.new
      w.identifier=([{'displayLabel' => 'sysnum', 'value' => sysnum }])
    end
    w
  end
end

# Helper class to give some useful
# functionality for handling file imports
# for BreveProjektet. It has no relation to Work
# or any other such Data Model classes, it
# is pure BreveProjekt business logic.
# Do not subclass or use in other contexts!!!
class LetterVolumeFile
  def initialize(path_string)
    @file_name = Pathname.new(path_string).basename.to_s
    @file = File.new(path_string)

    raise "invalid filename given: #{file_name}" unless @file_name.include?('_')
  end

  def sysnum
    @file_name.split('_').first
  end

  # if filename ends with underscore X number,
  # then this is a multivolume file
  def multivolume?
    @file_name.split('_').last[0].downcase == 'x'
  end

  # convert the last part of the filename to
  # an integer e.g. '0098372_X01.pdf'=> 1
  def number
    @file_name.split('_').last[1..-1].to_i
  end

  def index
    number - 1
  end

end