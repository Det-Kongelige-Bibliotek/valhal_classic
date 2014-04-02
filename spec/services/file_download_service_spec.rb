require 'spec_helper'

describe FileDownloadService do

  describe 'fetch_file_from_server' do
    it 'should successfully return a file via SCP' do

      data = FileDownloadService.new.fetch_file_from_server('programming-ruby-1-9-2-0_p1_0.pdf')
      data.should_not be_nil
      puts data.class.to_s
    end
  end
end