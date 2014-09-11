require 'spec_helper'
require 'resque'
require 'fakeredis'

describe "Search for new Letters Volume Job" do

  describe "perform" do

    before :all do
      @redis = Redis.new
      @queue = LetterVolumeIngest.instance_variable_get(:@queue)
      @processed_files = NewVolumesJob.instance_variable_get(:@PROCESSED_FILES)
      @redis.hset(@processed_files,"1","processed")
    end


    it "should throw an error if filesystem does not exist" do
      expect {
        NewVolumesJob.perform('/invalid/path')

      }.to raise_error
    end


    it "should search for new files and create a new LetterVolumeIngest job" do
      path = Rails.root.join('spec', 'fixtures', 'dk_breve')

      before = Resque.size(@queue)
      NewVolumesJob.perform(path)

      Resque.redis.hkeys(@queue).should == []
      @redis.hget(@processed_files,"2").should == "processed"

      Resque.size(@queue).should == before+1

      job = Resque.pop(@queue)
      job["class"].should == "LetterVolumeIngest"
      job["args"].size.should == 3
      job["args"][0].should == "#{path}/output/xml/2.xml"
      job["args"][1].should == "#{path}/output/pdf/2.pdf"
      job["args"][2].should == "#{path}/2"

    end
  end
end