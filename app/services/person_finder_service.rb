# This class is essentially a placeholder
# when jatr's work is done, we will merge
# the functionality with it.
module PersonFinderService


  # Given a MODS XML for a person
  # return a
  def find_or_create_person(mods_xml)

    name = parse_name(mods_xml)
    unless name.nil?
      hashed_name = hashify_personal_name(name)
      p = find_person_by_name(hashed_name)

      if p.nil?
        p = Person.new(hashed_name)
        p.save
      end
      p
    end
  end

  #Need to handle the use case where there is no author in a book
  #So if the CSS query returns nothing we need to stop further processing
  def parse_name(xml)
    xml_doc = Nokogiri::XML(xml)

    node_set = xml_doc.css("name namePart")

    if node_set.size > 0
      xml_doc.css("name namePart").first.text
    end
  end

  def find_person_by_name(hashed_name)
    Person.find(hashed_name).first
  end

  # Given a personal name in format
  # 'Mühlbach, Louise' convert to hash
  # in format {firstname: 'Louise', lastname: 'Mühlbach'}
  def hashify_personal_name(pers_name)
    names = pers_name.split(',')
    { lastname: names.first.strip, firstname: names.last.strip }
  end



end