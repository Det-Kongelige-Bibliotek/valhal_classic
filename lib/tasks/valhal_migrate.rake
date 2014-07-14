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
    ActiveFedora::Base.all.each do |b|
      if b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:Book')
        puts 'Migrating a Book:'
        migrate_book(b)
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:Work')
        #puts 'Migrating a Work:'
        #puts b.datastreams['RELS-EXT'].content
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:SingleFileRepresentation')
        #puts 'Migrating a SingleFileRepresentation:'
        #puts b.datastreams['RELS-EXT'].content
      elsif b.datastreams['RELS-EXT'].content.include?('info:fedora/afmodel:OrderedFileRepresentation')
        #puts 'Migrating a OrderedFileRepresentation:'
        #puts b.datastreams['RELS-EXT'].content
      else
        #puts 'Not migrating this!'
        #puts b.datastreams['RELS-EXT'].content
      end
    end
    #
  end

  # Migrate the old Book into the new Work.
  # Including relations, representation, and the relations from the representations to the files.
  # @param b The book to migrate.
  # @return The new Work.
  def migrate_book(b)
    puts b.datastreams['RELS-EXT'].content

    #puts b.datastreams['descMetadata'].content
    #w = TransformationService.create_from_mods(b.datastreams['descMetadata'].content)
  end

  def find_files(ids)

  end
end
