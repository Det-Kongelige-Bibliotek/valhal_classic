# -*- encoding : utf-8 -*-
#Class for retrieving files from internal servers at KB

require 'net/scp'

class FileDownloadService

  def initialize
    @dod_server = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]['dod_ebog_files']['dod_server']
    @dod_server_user = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]['dod_ebog_files']['user_name']
    @dod_server_password = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]['dod_ebog_files']['password']
    @dod_server_remote_path = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]['dod_ebog_files']['remote_path']
    @dod_server_download_path = YAML.load_file("#{Rails.root}/config/services.yml")[Rails.env]['dod_ebog_files']['download_path']
  end

  #Fetch a file from an internal server using the file_details data
  #@param file_name String for object of the requested file
  #@return File the requested file
  def fetch_file_from_server(file_name)
    start_time = Time.now
    logger.debug "Starting retrieval of #{file_name}"

    begin
      Net::SCP.download!(@dod_server, @dod_server_user, @dod_server_remote_path.concat(file_name), @dod_server_download_path,
                                :ssh => {:password => @dod_server_password}) do |ch, name, received, total|
        # Calculate percentage complete and format as a two-digit percentage
        percentage = format('%.2f', received.to_f / total.to_f * 100) + '%'

        # Print on top of (replace) the same line in the terminal
        # - Pad with spaces to make sure nothing remains from the previous output
        # - Add a carriage return without a line feed so the line doesn't move down
        print "Saving to #{name}: Received #{received} of #{total} bytes" + " (#{percentage})               \r"

        # Print the output immediately - don't wait until the buffer fills up
        STDOUT.flush
      end
      logger.debug "SCP of PDF from file server took: #{Time.now - start_time} seconds"
    rescue Net::SCP::Error => scp_error
      logger.error "There was an SCP error:  #{scp_error.message}"
      puts scp_error.message
    end
    file = ActionDispatch::Http::UploadedFile.new(tempfile: File.open("#{@dod_server_download_path}/#{file_name}"))
  end

end