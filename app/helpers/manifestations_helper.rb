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

  # add the file as a single file representation to the work.
  def add_single_file_representation(file, params, manifestation)
    if file.nil? or work.nil?
      return false
    end

    rep = SingleFileRepresentation.new(params)
    rep.save!

    rep_file = BasicFile.new
    rep_file.add_file(file)
    rep.files << rep_file
    manifestation.representations << rep

    manifestation.save!
  end
end
