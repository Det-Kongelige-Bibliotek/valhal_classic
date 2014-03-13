# This class is essentially a placeholder
# when jatr's work is done, we will merge
# the functionality with it.
class PersonFinderService


  # Given a MODS XML for a person
  # return a
  def find_or_create_person(mods_xml)
    hashed_name = hashify_personal_name(parse_name(mods_xml))

    find_person_by_name(hashed_name) || Person.new(hashed_name).save
  end

  def parse_name(xml)
    xml_doc = Nokogiri::XML(xml)
    xml_doc.css("name namePart").first.text
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