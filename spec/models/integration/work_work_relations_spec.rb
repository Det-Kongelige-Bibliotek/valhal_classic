# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Relationships between works" do
  describe "Next/Previous in sequence" do
    before :each do
        @work1 = Work.create(:title => 'Letter no 1 ' + Time.now.nsec.to_s)
        @work2 = Work.create(:title => 'Letter no 2 ' + Time.now.nsec.to_s)
    end

    it "should be possible to define the next work in sequence with a corresponing previous in sequence" do
      @work2.previousInSequence = @work1
      @work1.nextInSequence << @work2;
      @work1.save!
      @work1.reload
      @work2.reload

      @work1.nextInSequence.should == [@work2]
      @work2.previousInSequence.should == @work1
    end
  end
end