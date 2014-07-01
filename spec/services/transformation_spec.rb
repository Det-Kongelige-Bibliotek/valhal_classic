require 'spec_helper'

describe "transformation" do
  before :all do
    class WorkTestClass < ActiveFedora::Base
      include Concerns::WorkInstanceRelations
      has_metadata :name => 'descMetadata', :type => Datastreams::WorkDescMetadata
    end
  end

  describe "Work" do
    before :all do
      @work = WorkTestClass.create

    end
    it 'should be possible to extract the metadata' do

    end
  end

end
