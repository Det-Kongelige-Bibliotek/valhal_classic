namespace :valhal_migrate do
  logger = ActiveSupport::TaggedLogging.new(Logger.new("./log/#{ENV['RAILS_ENV']}.log"))
  desc "Add file_uuid to all BasicFile objects"
  task :file_uuid => :environment do
    logger.tagged('MIGRATE_FILE_UUID') { logger.debug 'Starting addition of file_uuid to BasicFile objects...'}
    BasicFile.all.each do |bf|
      if bf.file_uuid.blank?
        begin
          bf.file_uuid = UUID.new.generate
          bf.save!
        rescue Exception => e
          logger.tagged('MIGRATE_FILE_UUID') { logger.error e }
          break
        end
      end
    end
    TiffFile.all.each do |tf|
      if tf.file_uuid.blank?
        begin
          tf.file_uuid = UUID.new.generate
          tf.save!
        rescue Exception => e
          logger.tagged('MIGRATE_FILE_UUID') { logger.error e }
          break
        end
      end
    end
    logger.tagged('MIGRATE_FILE_UUID') { logger.debug 'Finished addition of file_uuid to BasicFile objects'}
  end

  desc 'Move from current model to the new conceptual model.'
  task :conceptual_model => :environment do

    logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.debug 'Starting migration to new data model...'}
    
    book_and_works = []
    books = []
    files = []
    tei_files = []
    reps = []
    people = []
    failed = {}

    book_and_works << ActiveFedora::Base.find('sifd:130469').pid
    books << ActiveFedora::Base.find('sifd:130469').pid
    reps << ActiveFedora::Base.find('sifd:130508').pid
    reps << ActiveFedora::Base.find('sifd:131717').pid
    people << ActiveFedora::Base.find('sifd:1528').pid
    files << ActiveFedora::Base.find('sifd:130507').pid #single file
    files << ActiveFedora::Base.find('sifd:130509').pid
    files << ActiveFedora::Base.find('sifd:130516').pid
    files << ActiveFedora::Base.find('sifd:130514').pid
    files << ActiveFedora::Base.find('sifd:130520').pid
    files << ActiveFedora::Base.find('sifd:130512').pid
    files << ActiveFedora::Base.find('sifd:130538').pid
    files << ActiveFedora::Base.find('sifd:130545').pid
    files << ActiveFedora::Base.find('sifd:130528').pid
    files << ActiveFedora::Base.find('sifd:130523').pid
    files << ActiveFedora::Base.find('sifd:130532').pid
    files << ActiveFedora::Base.find('sifd:130552').pid
    files << ActiveFedora::Base.find('sifd:130559').pid
    files << ActiveFedora::Base.find('sifd:130566').pid
    files << ActiveFedora::Base.find('sifd:130573').pid
    files << ActiveFedora::Base.find('sifd:130585').pid
    files << ActiveFedora::Base.find('sifd:130579').pid
    files << ActiveFedora::Base.find('sifd:130594').pid
    files << ActiveFedora::Base.find('sifd:130600').pid
    files << ActiveFedora::Base.find('sifd:130607').pid
    files << ActiveFedora::Base.find('sifd:130614').pid
    files << ActiveFedora::Base.find('sifd:130621').pid
    files << ActiveFedora::Base.find('sifd:130628').pid
    files << ActiveFedora::Base.find('sifd:130633').pid
    files << ActiveFedora::Base.find('sifd:130640').pid
    files << ActiveFedora::Base.find('sifd:130648').pid
    files << ActiveFedora::Base.find('sifd:130654').pid
    files << ActiveFedora::Base.find('sifd:130662').pid
    files << ActiveFedora::Base.find('sifd:130669').pid
    files << ActiveFedora::Base.find('sifd:130676').pid
    files << ActiveFedora::Base.find('sifd:130681').pid
    files << ActiveFedora::Base.find('sifd:130687').pid
    files << ActiveFedora::Base.find('sifd:130695').pid
    files << ActiveFedora::Base.find('sifd:130701').pid
    files << ActiveFedora::Base.find('sifd:130708').pid
    files << ActiveFedora::Base.find('sifd:130714').pid
    files << ActiveFedora::Base.find('sifd:130722').pid
    files << ActiveFedora::Base.find('sifd:130728').pid
    files << ActiveFedora::Base.find('sifd:130735').pid
    files << ActiveFedora::Base.find('sifd:130742').pid
    files << ActiveFedora::Base.find('sifd:130749').pid
    files << ActiveFedora::Base.find('sifd:130755').pid
    files << ActiveFedora::Base.find('sifd:130763').pid
    files << ActiveFedora::Base.find('sifd:130769').pid
    files << ActiveFedora::Base.find('sifd:130776').pid
    files << ActiveFedora::Base.find('sifd:130782').pid
    files << ActiveFedora::Base.find('sifd:130789').pid
    files << ActiveFedora::Base.find('sifd:130822').pid
    files << ActiveFedora::Base.find('sifd:130796').pid
    files << ActiveFedora::Base.find('sifd:130803').pid
    files << ActiveFedora::Base.find('sifd:130810').pid
    files << ActiveFedora::Base.find('sifd:130816').pid
    files << ActiveFedora::Base.find('sifd:130837').pid
    files << ActiveFedora::Base.find('sifd:130831').pid
    files << ActiveFedora::Base.find('sifd:130843').pid
    files << ActiveFedora::Base.find('sifd:130849').pid
    files << ActiveFedora::Base.find('sifd:130855').pid
    files << ActiveFedora::Base.find('sifd:130891').pid
    files << ActiveFedora::Base.find('sifd:130864').pid
    files << ActiveFedora::Base.find('sifd:130870').pid
    files << ActiveFedora::Base.find('sifd:130876').pid
    files << ActiveFedora::Base.find('sifd:130883').pid
    files << ActiveFedora::Base.find('sifd:130896').pid
    files << ActiveFedora::Base.find('sifd:130902').pid
    files << ActiveFedora::Base.find('sifd:130909').pid
    files << ActiveFedora::Base.find('sifd:130916').pid
    files << ActiveFedora::Base.find('sifd:130923').pid
    files << ActiveFedora::Base.find('sifd:130930').pid
    files << ActiveFedora::Base.find('sifd:130936').pid
    files << ActiveFedora::Base.find('sifd:130943').pid
    files << ActiveFedora::Base.find('sifd:130950').pid
    files << ActiveFedora::Base.find('sifd:130957').pid
    files << ActiveFedora::Base.find('sifd:130963').pid
    files << ActiveFedora::Base.find('sifd:130971').pid
    files << ActiveFedora::Base.find('sifd:130977').pid
    files << ActiveFedora::Base.find('sifd:130984').pid
    files << ActiveFedora::Base.find('sifd:130991').pid
    files << ActiveFedora::Base.find('sifd:130998').pid
    files << ActiveFedora::Base.find('sifd:131004').pid
    files << ActiveFedora::Base.find('sifd:131010').pid
    files << ActiveFedora::Base.find('sifd:131018').pid
    files << ActiveFedora::Base.find('sifd:131025').pid
    files << ActiveFedora::Base.find('sifd:131031').pid
    files << ActiveFedora::Base.find('sifd:131038').pid
    files << ActiveFedora::Base.find('sifd:131043').pid
    files << ActiveFedora::Base.find('sifd:131050').pid
    files << ActiveFedora::Base.find('sifd:131058').pid
    files << ActiveFedora::Base.find('sifd:131064').pid
    files << ActiveFedora::Base.find('sifd:131076').pid
    files << ActiveFedora::Base.find('sifd:131085').pid
    files << ActiveFedora::Base.find('sifd:131091').pid
    files << ActiveFedora::Base.find('sifd:131097').pid
    files << ActiveFedora::Base.find('sifd:131103').pid
    files << ActiveFedora::Base.find('sifd:131112').pid
    files << ActiveFedora::Base.find('sifd:131118').pid
    files << ActiveFedora::Base.find('sifd:131125').pid
    files << ActiveFedora::Base.find('sifd:131132').pid
    files << ActiveFedora::Base.find('sifd:131139').pid
    files << ActiveFedora::Base.find('sifd:131146').pid
    files << ActiveFedora::Base.find('sifd:131152').pid
    files << ActiveFedora::Base.find('sifd:131159').pid
    files << ActiveFedora::Base.find('sifd:131165').pid
    files << ActiveFedora::Base.find('sifd:131172').pid
    files << ActiveFedora::Base.find('sifd:131179').pid
    files << ActiveFedora::Base.find('sifd:131185').pid
    files << ActiveFedora::Base.find('sifd:131192').pid
    files << ActiveFedora::Base.find('sifd:131200').pid
    files << ActiveFedora::Base.find('sifd:131206').pid
    files << ActiveFedora::Base.find('sifd:131226').pid
    files << ActiveFedora::Base.find('sifd:131212').pid
    files << ActiveFedora::Base.find('sifd:131219').pid
    files << ActiveFedora::Base.find('sifd:131239').pid
    files << ActiveFedora::Base.find('sifd:131233').pid
    files << ActiveFedora::Base.find('sifd:131247').pid
    files << ActiveFedora::Base.find('sifd:131253').pid
    files << ActiveFedora::Base.find('sifd:131260').pid
    files << ActiveFedora::Base.find('sifd:131267').pid
    files << ActiveFedora::Base.find('sifd:131280').pid
    files << ActiveFedora::Base.find('sifd:131286').pid
    files << ActiveFedora::Base.find('sifd:131306').pid
    files << ActiveFedora::Base.find('sifd:131294').pid
    files << ActiveFedora::Base.find('sifd:131300').pid
    files << ActiveFedora::Base.find('sifd:131314').pid
    files << ActiveFedora::Base.find('sifd:131321').pid
    files << ActiveFedora::Base.find('sifd:131347').pid
    files << ActiveFedora::Base.find('sifd:131327').pid
    files << ActiveFedora::Base.find('sifd:131333').pid
    files << ActiveFedora::Base.find('sifd:131341').pid
    files << ActiveFedora::Base.find('sifd:131353').pid
    files << ActiveFedora::Base.find('sifd:131360').pid
    files << ActiveFedora::Base.find('sifd:131367').pid
    files << ActiveFedora::Base.find('sifd:131373').pid
    files << ActiveFedora::Base.find('sifd:131380').pid
    files << ActiveFedora::Base.find('sifd:131406').pid
    files << ActiveFedora::Base.find('sifd:131386').pid
    files << ActiveFedora::Base.find('sifd:131394').pid
    files << ActiveFedora::Base.find('sifd:131413').pid
    files << ActiveFedora::Base.find('sifd:131421').pid
    files << ActiveFedora::Base.find('sifd:131427').pid
    files << ActiveFedora::Base.find('sifd:131433').pid
    files << ActiveFedora::Base.find('sifd:131440').pid
    files << ActiveFedora::Base.find('sifd:131446').pid
    files << ActiveFedora::Base.find('sifd:131453').pid
    files << ActiveFedora::Base.find('sifd:131459').pid
    files << ActiveFedora::Base.find('sifd:131466').pid
    files << ActiveFedora::Base.find('sifd:131486').pid
    files << ActiveFedora::Base.find('sifd:131473').pid
    files << ActiveFedora::Base.find('sifd:131479').pid
    files << ActiveFedora::Base.find('sifd:131493').pid
    files << ActiveFedora::Base.find('sifd:131500').pid
    files << ActiveFedora::Base.find('sifd:131506').pid
    files << ActiveFedora::Base.find('sifd:131514').pid
    files << ActiveFedora::Base.find('sifd:131520').pid
    files << ActiveFedora::Base.find('sifd:131526').pid
    files << ActiveFedora::Base.find('sifd:131533').pid
    files << ActiveFedora::Base.find('sifd:131540').pid
    files << ActiveFedora::Base.find('sifd:131547').pid
    files << ActiveFedora::Base.find('sifd:131560').pid
    files << ActiveFedora::Base.find('sifd:131553').pid
    files << ActiveFedora::Base.find('sifd:131567').pid
    files << ActiveFedora::Base.find('sifd:131573').pid
    files << ActiveFedora::Base.find('sifd:131580').pid
    files << ActiveFedora::Base.find('sifd:131587').pid
    files << ActiveFedora::Base.find('sifd:131594').pid
    files << ActiveFedora::Base.find('sifd:131600').pid
    files << ActiveFedora::Base.find('sifd:131614').pid
    files << ActiveFedora::Base.find('sifd:131607').pid
    files << ActiveFedora::Base.find('sifd:131646').pid
    files << ActiveFedora::Base.find('sifd:131626').pid
    files << ActiveFedora::Base.find('sifd:131620').pid
    files << ActiveFedora::Base.find('sifd:131640').pid
    files << ActiveFedora::Base.find('sifd:131633').pid
    files << ActiveFedora::Base.find('sifd:131653').pid
    files << ActiveFedora::Base.find('sifd:131660').pid
    files << ActiveFedora::Base.find('sifd:131666').pid
    files << ActiveFedora::Base.find('sifd:131674').pid
    files << ActiveFedora::Base.find('sifd:131700').pid
    files << ActiveFedora::Base.find('sifd:131707').pid
    files << ActiveFedora::Base.find('sifd:131687').pid
    files << ActiveFedora::Base.find('sifd:131680').pid
    files << ActiveFedora::Base.find('sifd:131693').pid
=begin
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
        # Needs to be converted before usage
        tei_files << b.pid
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:Person')
        people << b.pid
      end
=end

    people_relations = extract_people_relations(people)

    migrated_people = Hash.new
    failed[:people] = []
    people.each do |p|
      begin
        migrated_people[p] = migrate_people(p)
      rescue => e
        failed[:people] << p
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error "could not migrate person #{p}" }
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
      end
    end

    tei_files.each do |f|
      convert_tei_file(f)
      files << f
    end

    rep_files = extract_rep_relations_to_files(reps, files)
    book_work_relations = extract_work_book_relations_to_reps(book_and_works, rep_files)

    migrated_works = Hash.new
    failed[:works]
    book_and_works.each do |b|
      begin
        migrated_works[b] = migrate_book_or_work(b, book_work_relations[b])
      rescue => e
        failed[:works] << b
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error "could not migrate book or work #{b}" }
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
      end
    end

    books.each do |book|
      work = migrated_works[book]
      work.workType = 'Book' unless work.nil?
      begin
        work.save unless work.nil?
      rescue => e
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error "could not save new work #{work}" }
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
      end
    end

    insert_relations(migrated_works, migrated_people, people_relations)

    legacy = []
    legacy = book_and_works + reps + people
    failed[:deletes] = []
    legacy.each do |l|
      begin
        lbase = ActiveFedora::Base.find(l, :cast=>false)
        lbase.delete
      rescue => e
        failed[:deletes] << l
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error "could not migrate legacy work #{l}" }
      end
    end

    File.new('failed.txt', 'wb').write(failed.to_s)
    logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.debug 'Finished migration to new data model.'}
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
      begin
        rep = ActiveFedora::Base.find(k, :cast=>false)
        search_start = rep.datastreams['RELS-EXT'].content.index(':hasSubset')
        search_end = rep.datastreams['RELS-EXT'].content.index('hasSubset>')
        unless search_start.nil? || search_end.nil?
          bw_id = rep.datastreams['RELS-EXT'].content[search_start + 37, (search_end - search_start) - 45]
          if book_and_works.include?(bw_id)
            res[bw_id] = [] if res[bw_id].nil?
            res[bw_id] << {k => v}
          end
        end
      rescue => e
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
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
      begin
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
      rescue ActiveFedora::ObjectNotFoundError => e
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
      end
    end
    res
  end

  # Extracts the relations for person.
  # Creates a hash between the person-ID and a Hash between relation-type and a list of works/books.
  # @param people The people to extract the relations from.
  # @return A hash between each person and its relations to books/works.
  def extract_people_relations(people)
    res = Hash.new
    people.each do |f|
      begin
        base = ActiveFedora::Base.find(f, :cast => false)
        match_concerns_relations = base.datastreams['RELS-EXT'].content.scan(/(:hasDescription[^>]*><)/)

        concerns = []
        match_concerns_relations.each do |c|
          relation = c.first
          concerns << relation[42, relation.size-45]
        end

        match_author_relations = base.datastreams['RELS-EXT'].content.scan(/(:isMemberOf[^>]*><)/)

        author = []
        match_author_relations.each do |c|
          relation = c.first
          author << relation[38, relation.size-41]
        end

        res[f] = {'Author' => author, 'Concerns' => concerns}
      rescue ActiveFedora::ObjectNotFoundError => e
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
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

    begin
      base = ActiveFedora::Base.find(bw, :cast=>false)

      mods = Nokogiri::XML.parse(base.datastreams['descMetadata'].content)

      files = relations.empty? ? [] : extract_files(relations.first.values.first)

      work, instance = TransformationService.create_from_mods(mods, files)
      work.datastreams['preservationMetadata'].content = base.datastreams['preservationMetadata'].content

      if relations.size > 1
        for i in 1 .. relations.size - 1
          add_copy_of_instance(work, instance, relations[i].values)
        end
      end
      work
    rescue ActiveFedora::ObjectNotFoundError => e
      logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
    end
  end

  # Migrate the old Person into the new AMU Agent/Person.
  # Transforms from four fields: 'firstname', 'lastname', 'date_of_birth' and 'date_of_death'
  # into: 'lastname', 'firstname' ('date_of_birth' - 'date_of_death')
  # TODO needs to figure out what to do, when firstname, lastname, date of birth and/or date of death is missing.
  # @param p The Person or work to migrate.
  # @return The new Agent/Person.
  def migrate_people(p)
    begin
      base = ActiveFedora::Base.find(p, :cast=>false)

      pxml = Nokogiri::XML.parse(base.datastreams['descMetadata'].content)
      firstname = pxml.css("//fields/firstname").text
      lastname = pxml.css("//fields/lastname").text
      date_of_birth = pxml.css("//fields/date_of_birth").text
      date_of_death = pxml.css("//fields/date_of_death").text

      lastname = 'Ukendt' if lastname.blank?

      p = Person.new(title: "", firstName: firstname, lastName: lastname, dateOfBirth: date_of_birth, dateOfDeath: date_of_death, type: "agent/person")
      p.save
    rescue ActiveFedora::ObjectNotFoundError => e
      logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
    end
  end

  def insert_relations(migrated_works, migrated_people, relations)
    relations.each do |p, rel|
      rel['Author'].each do |a|
        unless migrated_works[a].nil? || migrated_people[p].nil?
          migrated_works[a].hasAuthor << migrated_people[p]
          migrated_works[a].save
        end
      end
      rel['Concerns'].each do |a|
        unless migrated_works[a].nil? || migrated_people[p].nil?
          migrated_works[a].hasTopic << migrated_people[p] unless migrated_works[a].nil?
          migrated_works[a].save unless migrated_works[a].nil?
        end
      end
    end
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
      begin
        files << BasicFile.find(f)
      rescue ActiveFedora::ObjectNotFoundError => e
        logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
      end
    end
    logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.debug "Files array size = #{files.size}" }
    files
  end

  # Converts a TEI file into a Basic file.
  # Just change the model in the RELS-EXT.
  def convert_tei_file(id)
    begin
      f = BasicFile.find(id)

      f.datastreams['RELS-EXT'].content = f.datastreams['RELS-EXT'].content.gsub('info:fedora/afmodel:TeiFile', 'info:fedora/afmodel:BasicFile')
      f.save
    rescue ActiveFedora::ObjectNotFoundError => e
      logger.tagged('CONCEPTUAL_MODEL_MIGRATE') { logger.error e }
      return
    end
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
