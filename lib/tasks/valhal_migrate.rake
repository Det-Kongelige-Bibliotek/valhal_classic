namespace :valhal_migrate do
  desc "Add file_uuid to all BasicFile objects"
  task :file_uuid => :environment do
    BasicFile.all.each do |bf|
      if bf.file_uuid.blank?
        bf.file_uuid = UUID.new.generate
        bf.save!
      end
    end
    TiffFile.all.each do |tf|
      if tf.file_uuid.blank?
        tf.file_uuid = UUID.new.generate
        tf.save!
      end
    end
  end

  desc 'Move from current model to the new conceptual model.'
  task :conceptual_model => :environment do
    book_and_works = []
    files = []
    tei_files = []
    reps = []
    ActiveFedora::Base.all.each do |b|
      if b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:Book')
        book_and_works << b.pid
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:Work')
        book_and_works << b.pid
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:SingleFileRepresentation')
        reps << b.pid
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:OrderedRepresentation')
        reps << b.pid
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:BasicFile')
        files << b.pid
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:TiffFile')
        files << b.pid
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:TeiFile')
        # Needs also to be converted
        tei_files << b.pid
        files << b.pid
      end
    end


    puts "Books and works: #{book_and_works}"
    puts "Representations: #{reps}"
    puts "files: #{files}"

    rep_files = extract_rep_relations_to_files(reps, files)
    book_work_relations = extract_work_book_relations_to_reps(book_and_works, rep_files)

    book_and_works.each do |b|
      migrate_book_or_work(b, book_work_relations[b])
    end
    #
  end

  def extract_work_book_relations_to_reps(book_and_works, rep_relations)
    res = Hash.new
    rep_relations.each do |k, v|
      rep = ActiveFedora::Base.find(k, :cast=>false)
      search_start = rep.datastreams['RELS-EXT'].content.index(':hasSubset')
      search_end = rep.datastreams['RELS-EXT'].content.index('hasSubset>')
      bw_id = rep.datastreams['RELS-EXT'].content[search_start + 37, (search_end - search_start) - 45]
      if book_and_works.include?(bw_id)
        res[bw_id] = [] if res[bw_id].nil?
        res[bw_id] << {k => v}
      end
    end
    res
  end

  def extract_rep_relations_to_files(reps, files)
    res = Hash.new
    files.each do |f|
      file = ActiveFedora::Base.find(f, :cast=>false)
      search_start = file.datastreams['RELS-EXT'].content.index(':isPartOf')
      search_end = file.datastreams['RELS-EXT'].content.index('isPartOf>')
      # Magic numbers 36 and 44 -> finds the start and end of the representation 'PID' within the RELS-EXT
      rep_id = file.datastreams['RELS-EXT'].content[search_start + 36, (search_end - search_start) - 44]
      if reps.include?(rep_id)
        res[rep_id].nil? ? res[rep_id] = [f] : res[rep_id] << f
      end
    end
    res
  end

  # Migrate the old Book into the new Work.
  # Including relations, representation, and the relations from the representations to the files.
  # @param bw The book or work to migrate.
  # @param relations The relations for the book or work.
  # @return The new Work.
  def migrate_book_or_work(bw, relations)
    puts "Migrating #{bw} with relations #{relations}"
    return if relations.nil?
    base = ActiveFedora::Base.find(bw, :cast=>false)
    #puts base.datastreams['descMetadata'].content

    #puts relations.last.values
    mods = Nokogiri::XML.parse(base.datastreams['descMetadata'].content)
    #puts mods
    #puts TransformationService.create_from_mods(mods, relations.last.values)
    w, i = TransformationService.create_from_mods(mods, relations.last.values)
    puts w.inspect
    puts i.inspect
  end

  def find_files(ids)

  end
end
