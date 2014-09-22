class LetterVolumeSplitter

  @queue = :letter_volume_splitter

  # Given a reference to a work
  # and a docx derived xml file, create a Work object
  # for each letter with metadata parsed from
  # the result of the xml transform
  def self.perform(work_pid, xml_pid)
    master_work = Work.find(work_pid)
    xml = BasicFile.find(xml_pid)

    raise "Work with pid #{work_pid} not found!" unless master_work
    raise "BasicFile with pid #{xml_pid} not found!" unless xml

    tei = Nokogiri::XML(xml.content.content)
    self.parse_letters(tei, master_work)
  end

  # Given a tei xml doc, create a work
  # for each letter with a relation to
  # a given master work
  # @param Nokogiri::XML::Document
  # @param Work master_work
  def self.parse_letters(tei, master_work)
    divs = tei.css('text body div')
    start_page_break = tei.css('pb').first.attr('n')
    raise 'First page break does not have n attribute' if start_page_break.nil?
    # file prefix is the volume name, the same as a jpgs name without the last 4 digits and the .jpg
    file_prefix = master_work.ordered_instance_types[:jpgs].files.first.original_filename.sub(/_\d{4}.jpg/, '')
    # Create Works for each letter with relations
    # to the previous letter and the master work
    prev_letter = nil
    divs.each do |div|
      prev_letter, start_page_break = self.create_letter(div, prev_letter, master_work, start_page_break, file_prefix)
      prev_letter.save
    end
  end

  # Given an xml element representing a
  # TEI div - create a letter work with
  # a relation to the previous work and the
  # master work
  # @param Nokogiri::XML::Element div
  # @param Work prev_letter
  # @param Work master_work
  # @return Work (the new letter), String last_page
  def self.create_letter(div, prev_letter, master_work, first_page, file_prefix)
    data = self.parse_data(div, first_page)
    letter = Work.new
    letter.workType = 'Letter'
    letter.note = [data[:note]] if data[:note]
    letter.dateCreated = data[:date] if data[:date]
    letter.identifier= [{'displayLabel' => 'teiRef', 'value' => data[:id]}] if data[:id]
    if data[:sender_name]
      author = Person.from_string(data[:sender_name])
      letter.hasAuthor << author
    end
    if data[:recipient_name]
      recipient = Person.from_string(data[:recipient_name].strip)
      letter.hasAddressee << recipient
    end
    if data[:sender_address]
      sender_address = Place.create(name: data[:sender_address])
      letter.hasOrigin << sender_address
    end
    file_path = self.save_to_file(data[:id], div)
    inst = SingleFileInstance.new_from_file(File.new(file_path))
    letter.add_instance(inst)
    letter = self.create_jpg_oi(letter, data, file_prefix)
    master_work.add_part(letter)
    letter.add_previous(prev_letter) unless prev_letter.nil?
    letter.save
    File.delete(file_path)
    # we need to return the last page found
    # in order to create the next start page
    [ letter, data[:end_page] ]
  end

  # given a work and a data array containing
  # a start and end page, create an ordered
  # representation representing these files
  #
  def self.create_jpg_oi(work, data, file_prefix)
    pics = OrderedInstance.new(contentType: 'jpg')
    start_page = data[:start_page].to_i
    end_page = data[:end_page].to_i
    (start_page..end_page).each do |num|
      filename = self.create_filename(file_prefix, num.to_s)
      file = BasicFile.find(original_filename_ssi: filename).first
      if file.nil?
        logger.error "Work #{work.pid}: #{filename} not found in index"
        Resque.logger.error "#{filename} not found in index"
      else
        logger.debug "Work #{work.pid}: adding #{filename} to ordered instance"
        pics.files << file
      end
    end
    pics.save
    work.add_instance(pics)
    work
  end

  # Given an id and and a Nokogiri
  # XML element - save the xml to a
  # file named by the id and return a
  # file path
  # @param id String
  # @param xml Nokogiri::XML::Node
  def self.save_to_file(id, xml)
    name = id || "Letter imported " + Time.now.to_s
    name += '.xml'
    file_path = Rails.root.join('tmp', name)
    File.write(file_path, xml.to_xml)
    file_path
  end


  # Given a Nokogiri::XML::Element
  # representing a single div
  # return a hash of metadata parsed from this element
  # @param Nokogiri::XML::Element
  # @return Hash
  def self.parse_data(div, first_page)
    data = Hash.new
    letter = LetterData.new(div)
    data[:id] = letter.id
    data[:num] = letter.num
    data[:date] = letter.date
    data[:body] = letter.body
    data[:sender_name] = letter.sender_name
    data[:recipient_name] = letter.recipient_name
    data[:sender_address] = letter.sender_address
    data[:needs_attention] = letter.needs_attention?
    data[:note] = letter.note
    data[:start_page] = (first_page.to_i + 2).to_s
    # if the div has a pagebreak, endpage is the value
    # of the last pagebreak, otherwise it's the start page
    end_page = div.css('pb').last ? div.css('pb').last.attr('n') : first_page
    data[:end_page] = (end_page.to_i + 2).to_s
    data
  end


  # work out the jpg filename based on the
  # prefix and filenum
  # e.g. "001003574_000", "4" ==>  "001003574_000_0004.jpg"
  # @param String, String
  # @return String
  def self.create_filename(prefix, file_num)
    prefix +  '_' + file_num.rjust(4, '0') + '.jpg'
  end
end

# Helper class to wrap some of the parsing logic
class LetterData

  # @param Nokogiri::XML::Document div
  def initialize(div)
    @div = div
  end

  def id
    @div.attributes['id'].value
  end

  def num
    @div['n']
  end

  def date
    @div.css('date').first.text if @div.css('date').length > 0
  end

  def body
    @div.text
  end

  def note
    if @div.css('note').length > 0
      val = @div.css('note').first.text
      {displayLabel: 'noteFromText', value: val}
    end
  end

  def sender_name
    @div.css('persName[type="sender"]').first.text if @div.css('persName[type="sender"]').length > 0
  end

  def recipient_name
    @div.css('address name').first.text if @div.css('address name').length > 0
  end

  def sender_address
    @div.css('placeName[type="sender"]').first.text if @div.css('placeName[type="sender"]').length > 0
  end

  # If we have duplicate date or recipient fields we
  # are likely to have two letters within the same div
  # therefore we flag for manual attention
  def needs_attention?
    @div.css('date').size > 1 || @div.css('address name').size > 1
  end


end