class TestJob
  @queue = :test

  def self.perform(content)
    File.open('test_file.log', 'w') do |f|
      f.puts "Writing #{content} to file via Resque!!"
    end
  end
end