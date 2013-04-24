# -*- encoding : utf-8 -*-
module WorksHelper
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

  # adds the person defined in the params as described
  def add_described_people(ids, work)
    # add each described person to the work
    ids.each do |person_pid|
      if person_pid && !person_pid.empty?
        person = Person.find(person_pid)
        work.people_described << person

        # TODO: Relationship should not be defined both ways.
        person.describing_works << work
        person.save!
      end
    end
    work.save!
  end
end