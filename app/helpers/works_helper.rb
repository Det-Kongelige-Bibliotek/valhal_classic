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
end