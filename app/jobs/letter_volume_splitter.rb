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

    # Create Works for each letter with relations
    # to the previous letter and the master work
    prev_letter = nil
    divs.each do |div|
      prev_letter = self.create_letter(div, prev_letter, master_work)
    end
  end

  # Given an xml element representing a
  # TEI div - create a letter work with
  # a relation to the previous work and the
  # master work
  # @param Nokogiri::XML::Element
  # @param Work prev_letter
  # @param Work master_work
  # @return Work (the new letter)
  def self.create_letter(xml, prev_letter, master_work)
    data = self.parse_data(xml)
    letter = Work.new
    letter.workType = 'Letter'
    letter.note = [data[:note]] if data[:note]
    letter.dateCreated = data[:date] if data[:date]
    letter.identifier= [{'displayLabel' => 'teiRef', 'value' => data[:id]}] if data[:id]
    if data[:sender_name]
      author = AuthorityMetadataUnit.create(type: 'agent/person', value: data[:sender_name])
      letter.hasAuthor << author
    end
    if data[:recipient_name]
      recipient = AuthorityMetadataUnit.create(type: 'agent/person', value: data[:recipient_name])
      letter.hasAddressee << recipient
    end
    if data[:sender_address]
      sender_address = AMUFinderService.find_or_create_place(data[:sender_address], '')
      letter.hasOrigin << sender_address
    end
    master_work.add_part(letter)
    letter.add_previous(prev_letter) unless prev_letter.nil?
    letter.save
    letter
  end


  # Given a Nokogiri::XML::Element
  # representing a single div
  # return a hash of metadata parsed from this element
  # @param Nokogiri::XML::Element
  # @return Hash
  def self.parse_data(div)
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

    data
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