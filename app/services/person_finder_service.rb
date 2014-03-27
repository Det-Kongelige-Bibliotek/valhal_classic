# This class is essentially a placeholder
# when jatr's work is done, we will merge
# the functionality with it.
module PersonFinderService


  # Given a MODS XML for a person
  # return a
  def find_or_create_person(mods_xml)

    name = Name.new(mods_xml)
    unless name.text.nil?
      hashed_name = name.to_hash
      p = find_person_by_name(hashed_name)

      if p.nil?
        p = Person.new(hashed_name)
        p.save
      end
      p
    end
  end

  def find_person_by_name(hashed_name)
    Person.find(hashed_name).first
  end

end

# Helper class to create a name object with
# attributes text and type
class Name
  attr_reader :text, :type

  def initialize(mods)
    xml_doc = Nokogiri::XML(mods)

    node_set = xml_doc.css('name namePart')

    if node_set.size > 0
      @text = xml_doc.css('name namePart').first.text
      @type = xml_doc.css('name').first.attr('type')
    end
  end

  # return a hash of name
  # in the form { lastname: 'x', firstname: 'y'}
  # corporate authors should have not have a firstname
  def to_hash
    if @type == 'personal'
      names = @text.split(',')
      { lastname: names.first.strip, firstname: names.last.strip }
    else
      { lastname: @text }
    end
  end
end