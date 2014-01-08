namespace :valhal_migrate do
  desc "Add file_uuid to all BasicFile objects"
  task :file_uuid => :environment do
    BasicFile.all.each do |bf|
      if bf.file_uuid.blank?
        bf.file_uuid = UUID.new.generate
        bf.save!
      end
    end
    TeiFile.all.each do |tf|
      if tf.file_uuid.blank?
        tf.file_uuid = UUID.new.generate
        tf.save!
      end
    end
    TiffFile.all.each do |tf|
      if tf.file_uuid.blank?
        tf.file_uuid = UUID.new.generate
        tf.save!
      end
    end
  end
end
