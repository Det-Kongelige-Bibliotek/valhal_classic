require "resque"

class LetterVolumeIngest

  @queue = :letter_volume_ingest

  def self.perform(xml_path, pdf_path, jpgpath)
    sysnum = self.parse_sysnum(xml_path)
    unless pdf_path.include?(sysnum)
      raise 'File names do not match!'
    end
    # Check to see if book exists
    work = Work.find('sysnum_si' => sysnum).first || Work.create(identifier: [{'sysnum' => sysnum}])
    work
    # Find or create work
    # Add representation to work
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
end