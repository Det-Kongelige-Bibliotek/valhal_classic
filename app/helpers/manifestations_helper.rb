# -*- encoding : utf-8 -*-
module ManifestationsHelper
  # adds the people behind the ids as authors for the manifestation.
  def add_authors(ids, manifestation)
    if ids.blank? or manifestation.blank?
      return false
    end

    # add the authors to the work
    ids.each do |author_pid|
      if author_pid && !author_pid.empty?
        author = Person.find(author_pid)
        manifestation.authors << author
      end
    end
    manifestation.save!
  end

  # adds the person defined in the params as concerned_by the manifestation.
  def add_concerned_people(ids, manifestation)
    # add the authors to the book
    ids.each do |person_pid|
      if person_pid && !person_pid.empty?
        person = Person.find(person_pid)
        manifestation.people_concerned << person
      end
    end
    manifestation.save!
  end
end
