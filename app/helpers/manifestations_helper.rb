# -*- encoding : utf-8 -*-
module ManifestationsHelper
  # adds the people behind the ids as authors for the work.
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
end
