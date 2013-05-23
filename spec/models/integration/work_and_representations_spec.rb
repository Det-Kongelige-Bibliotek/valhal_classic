# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Work relationships' do
  describe '#single_file_representation' do
    before :each do
      @work = Work.create(:title => "The title")
      @rep = SingleFileRepresentation.create
    end

    it 'should be possible to define a relation from work, which can be viewed both ways' do
      @work.representations << @rep
      @work.save!

      @work.representations.should == [@rep]
      @rep.work.should == @work
    end

    it 'should be possible to have two representations defined from work' do
      rep2 = SingleFileRepresentation.create
      @work.representations << @rep << rep2
      @work.save!

      @work.representations.should == [@rep, rep2]
      @rep.work.should == @work
      rep2.work.should == @work
    end

    it 'should be possible to define a relation from the representation, which can be viewed both ways' do
      pending "Apparently the relationship cannot be made this way"
      @rep.ie = @work
      @rep.save!

      @rep.work.should == @work
      @work.representations.should == [@rep]
    end

    it 'should be possible to have two representations defined from the representations' do
      @rep.ie = @work
      @rep.save!
      @rep.reload
      rep2 = SingleFileRepresentation.create
      rep2.ie = @work
      rep2.save!
      rep2.reload

      @work.reload


      @rep.work.should == @work
      rep2.work.should == @work
      #@work.representations.should == [@rep, rep2]

    end
  end

  describe '#ordered_representation' do
    before :each do
      @work = Work.create(:title => "The title")
      @rep = OrderedRepresentation.create
    end

    it 'should be possible to define a relation from work, which can be viewed both ways' do
      @work.representations << @rep
      @work.save!

      @work.representations.should == [@rep]
      @rep.work.should == @work
    end

    it 'should be possible to have two representations defined from work' do
      rep2 = OrderedRepresentation.create
      @work.representations << @rep << rep2
      @work.save!

      @work.representations.should == [@rep, rep2]
      @rep.work.should == @work
      rep2.work.should == @work
    end

    it 'should be possible to define a relation from the representation, which can be viewed both ways' do
      pending "Apparently the relationship cannot be made this way"
      @rep.ie = @work
      @rep.save!

      @rep.work.should == @work
      @work.representations.should == [@rep]
    end

    it 'should be possible to have two representations defined from the representations' do
      pending "Apparently the relationship cannot be made this way"
      @rep.ie = @work
      @rep.save!
      rep2 = OrderedRepresentation.create
      rep2.ie = @work
      rep2.save!

      @work.representations.should == [@rep, rep2]
      @rep.work.should == @work
      rep2.work.should == @work
    end
  end

end
