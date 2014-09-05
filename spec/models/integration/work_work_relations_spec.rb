# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Relationships between works" do
  describe "Next/Previous in sequence" do
    before :each do
        @work1 = Work.new(:title => 'Letter no 1 ' + Time.now.nsec.to_s)
        @work2 = Work.new(:title => 'Letter no 2 ' + Time.now.nsec.to_s)
    end

    it "should be possible to define the previous work in sequence" do
      @work2.add_previous(@work1)
      @work1.reload
      @work2.reload

      @work1.nextInSequence.should == @work2.pid
      @work2.previousInSequence.should == @work1.pid
    end

    it 'should be possible to define the next work in sequence' do
      @work1.add_next(@work2)
      @work1.reload
      @work2.reload

      @work1.next_work.should == @work2
      @work2.previous_work.should == @work1
    end

    it 'should be possible to update the next work in a sequence' do
      @work1.add_next(@work2)

      w = Work.create(title: 'another sample')
      @work1.add_next(w)
      @work1.reload
      @work2.reload
      w.reload
      @work1.nextInSequence.should eql w.pid
      w.previousInSequence.should eql @work1.pid
      @work2.previousInSequence.should be_nil
    end

    it 'should be possible to update the previous work in a sequence' do
      @work1.add_previous(@work2)

      w = Work.create(title: 'another sample')
      @work1.add_previous(w)
      @work1.reload
      @work2.reload
      w.reload
      @work1.previousInSequence.should eql w.pid
      w.nextInSequence.should eql @work1.pid
      @work2.nextInSequence.should be_nil
    end

    it 'should be possible to define a work as part of another work' do
      master_work = Work.new(title: 'containing work')
      master_work.save
      master_work.add_part(@work1)
      master_work.add_part(@work2)
      master_work.reload
      master_work.parts.should be_an Array
      master_work.parts.should include @work1
      master_work.parts.should include @work2

      @work1.is_part_of.should be_a Work
      @work1.is_part_of.should eql master_work
      @work2.is_part_of.should eql master_work
    end
  end
end