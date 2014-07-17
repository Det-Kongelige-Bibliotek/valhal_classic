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
    books = []
    files = []
    tei_files = []
    reps = []
    ActiveFedora::Base.all.each do |b|
      if b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:Book')
        book_and_works << b.pid
        books << b.pid
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
      end
    end

    # TODO convert TEI files:
    tei_files.each do |f|
      convert_tei_file(f)
      files << f
    end

    rep_files = extract_rep_relations_to_files(reps, files)
    book_work_relations = extract_work_book_relations_to_reps(book_and_works, rep_files)

    migration = Hash.new
    book_and_works.each do |b|
      migration[b] = migrate_book_or_work(b, book_work_relations[b])
    end

    books.each do |book|
      work = migration[book]
      work.workType = 'Book' unless work.nil?
      work.save unless work.nil?
    end
    puts migration
  end

  # Extracts a hash containing the relation between works/books and representations (with their relations to files).
  # Goes through all representations, looks in their RELS-EXT datastream to find the id in the 'hasSubset' relation.
  # Uses magic numbers 37 and 45 for finding the start and end of the representation 'PID' within the RELS-EXT
  # TODO: Might be missing books/works without any representations.
  # @param book_and_works An array of IDs of the works and books
  # @param rep_relations A hash between representation IDs and the list of their files.
  # @return A hash mapping between work/book and a list of hash-mappings between representations and files.
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

  # Extracts a Hash containing the relations between representations and files.
  # Goes through all files, looks in their RELS-EXT datastream to find the id in the 'isPartOf' relation.
  # Uses magic numbers 36 and 44 for finding the start and end of the representation 'PID' within the RELS-EXT
  # TODO might be missing representations without any files...
  # @param reps An array of IDs of the representations
  # @param files An array of IDs of the files
  # @return A hash mapping between representations and the list of their files.
  def extract_rep_relations_to_files(reps, files)
    res = Hash.new
    files.each do |f|
      file = ActiveFedora::Base.find(f, :cast=>false)
      search_start = file.datastreams['RELS-EXT'].content.index(':isPartOf')
      search_end = file.datastreams['RELS-EXT'].content.index('isPartOf>')
      unless search_start.nil? || search_end.nil?
        # Magic numbers 36 and 44 -> finds the start and end of the representation 'PID' within the RELS-EXT
        rep_id = file.datastreams['RELS-EXT'].content[search_start + 36, (search_end - search_start) - 44]
        if reps.include?(rep_id)
          res[rep_id].nil? ? res[rep_id] = [f] : res[rep_id] << f
        end
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
    return if relations.nil?

    base = ActiveFedora::Base.find(bw, :cast=>false)

    mods = Nokogiri::XML.parse(base.datastreams['descMetadata'].content)

    files = relations.empty? ? [] : extract_files(relations.first.values.first)

    work, instance = TransformationService.create_from_mods(mods, files)

    if relations.size > 1
      for i in 1 .. relations.size - 1
        add_copy_of_instance(work, instance, relations[i].values)
      end
    end
    work
  end

  # Add a new instance to the work
  # The new instance has the same metadata as the instance in the arguments, and it has the files of the file_ids.
  # @param work The work which the new instance is added to.
  # @param instance The instance to copy metadata from.
  # @param file_ids The ids of the files to add to the new instance.
  # @return The new instance.
  def add_copy_of_instance(work, instance, file_ids)
    files = extract_files(file_ids.first)
    i = create_copy_of_instance(instance, files.size)
    i.files << files

    work.instances << i
    i.ie = work
    work.save
    i.save
    i
  end

  # Extracts files based on a list of ids.
  # @param file_ids The list of IDs of the files.
  # @return An array containing the BasicFiles
  def extract_files(file_ids)
    files = []
    file_ids.each do |f|
      files << BasicFile.find(f)
    end
    files
  end

  # Converts a TEI file into a Basic file.
  # Just change the model in the RELS-EXT.
  def convert_tei_file(id)
    f = BasicFile.find(id)

    f.datastreams['RELS-EXT'].content = f.datastreams['RELS-EXT'].content.gsub('info:fedora/afmodel:TeiFile', 'info:fedora/afmodel:BasicFile')
    f.save
  end

  # Creates a copy of an instance, with same metadata - both internal metadata and AMU relations.
  # Uses the count to determine whether it should be a SingleFileInstance or OrderedInstance
  # @param instance The instance to copy the metadata from.
  # @param count The count to determine whether it should be a SingleFileInstance or OrderedInstance.
  # @return A new Instance with same metadata as the given instance.
  def create_copy_of_instance(instance, count)
    if count > 1
      i = OrderedInstance.create({'shelfLocator' => instance.shelfLocator,
                                  'dateCreated' => instance.dateCreated,
                                  'dateIssued' => instance.dateIssued,
                                  'tableOfContents' => instance.tableOfContents,
                                  'physicalDescriptionForm' => instance.physicalDescriptionForm,
                                  'physicalDescriptionNote' => instance.physicalDescriptionNote,
                                  'recordOriginInfo' => instance.recordOriginInfo,
                                  'languageOfCataloging' => instance.languageOfCataloging,
                                  'dateOther' => instance.dateOther})
    else
      i = SingleFileInstance.create({'shelfLocator' => instance.shelfLocator,
                                     'dateCreated' => instance.dateCreated,
                                     'dateIssued' => instance.dateIssued,
                                     'tableOfContents' => instance.tableOfContents,
                                     'physicalDescriptionForm' => instance.physicalDescriptionForm,
                                     'physicalDescriptionNote' => instance.physicalDescriptionNote,
                                     'recordOriginInfo' => instance.recordOriginInfo,
                                     'languageOfCataloging' => instance.languageOfCataloging,
                                     'dateOther' => instance.dateOther})
    end
    # Metadata objects
    i.identifier = instance.identifier
    i.note = instance.note

    # Relations
    i.hasTopic = instance.hasTopic
    i.hasContributor = instance.hasContributor
    i.hasOwner = instance.hasOwner
    i.hasPatron = instance.hasPatron
    i.hasPublisher = instance.hasPublisher
    i.hasPrinter = instance.hasPrinter
    i.hasScribe = instance.hasScribe
    i.hasDigitizer = instance.hasDigitizer
    i.hasOrigin = instance.hasOrigin
    i.save

    i
  end
end
