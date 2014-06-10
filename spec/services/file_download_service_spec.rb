require 'spec_helper'

describe FileDownloadService do

  describe 'fetch_file_from_server' do
    it 'should successfully return a file via SCP' do

      pending "Cannot be used externally, e.g. on Travis."
      file_download_service = FileDownloadService.new
      file = file_download_service.fetch_file_from_server('130020897792.pdf')
      file.should_not be_nil
      file.should be_kind_of ActionDispatch::Http::UploadedFile
      file.size.should equal(454564439)
    end

    after (:all) do
      pending "Cannot be used externally, e.g. on Travis."
      File.delete('/tmp/130020897792.pdf')
    end
  end
end
