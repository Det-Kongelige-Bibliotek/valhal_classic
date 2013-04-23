# -*- encoding : utf-8 -*-
module WorksHelper
  # adds the people behind the ids as authors for the work.
  def add_authors(ids, work)
    if ids.blank? or work.blank?
      return false
    end

    # add the authors to the work
    ids.each do |author_pid|
      if author_pid && !author_pid.empty?
        author = Person.find(author_pid)
        work.authors << author

        # TODO: Relationship should not be defined both ways.
        author.authored_works << work
        author.save!
      end
    end
    work.save!
  end

  # add the file as a single file representation to the work.
  def add_single_file_representation(file, params, work)
    if file.nil? or work.nil?
      return false
    end

    rep = SingleFileRepresentation.new(params)
    rep.save!

    rep_file = BasicFile.new
    rep_file.add_file(file)
    rep.files << rep_file
    work.representations << rep

    work.save!
  end
end
