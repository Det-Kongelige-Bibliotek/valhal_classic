require 'spec_helper'

describe 'DigitisationHelper' do

  describe 'Create new Work object' do

    before (:each) do
      @response_body = File.read("#{Rails.root}/spec/fixtures/testdod.pdf")
      stub_request(:get, "http://www.kb.dk/e-mat/dod/testdod.pdf").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.kb.dk', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => @response_body, :headers => {'Content-Type' => 'application/pdf'})
      stub_request(:get, "http://www.kb.dk/e-mat/dod/404.pdf").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.kb.dk', 'User-Agent'=>'Ruby'}).
          to_return(:status => 404, :body => '', :headers => {})

    end

    it "should create a new object with singlefile representation" do
      mods = File.open('spec/fixtures/mods_digitized_book.xml').read
      work = create_work_object(mods,"http://www.kb.dk/e-mat/dod/testdod.pdf")
      work.should_not be_nil
      work.title.should == 'En Formiddag hos Frederik den Store, historisk Charakteerbillede'
      work.work_type.should == 'DOD bog'
      work.single_file_reps.length.should == 1
      rep = work.single_file_reps[0]
      rep.should be_a_kind_of SingleFileRepresentation
      rep.files.length.should == 1
      file = rep.files[0]
      file.should be_a_kind_of BasicFile
      file.datastreams['content'].should_not be nil
    end

    it "should fail to create with invalid pdf Link" do
      mods = File.open('spec/fixtures/mods_digitized_book.xml').read
      work = create_work_object(mods,"asdfasdfasdf")
      work.should be nil

    end

    it "should fail to create with  pdf Link that do not respond 200" do
      mods = File.open('spec/fixtures/mods_digitized_book.xml').read
      work = create_work_object(mods,"http://www.kb.dk/e-mat/dod/404.pdf")
      work.should be nil

    end



  end
end