# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Work relationships' do
  describe '#single_file_representation' do
    before :each do
      @work = Work.create(:title => 'The title' + Time.now.nsec.to_s)
      @rep = SingleFileRepresentation.create
    end

    it 'should be possible to define a ordered relation from work, which can be viewed both ways' do
      @work.representations << @rep
      @work.save!

      @work.representations.should == [@rep]
      @rep.ie.should == @work
    end

    it 'should be possible to have two representations defined from work' do
      rep2 = SingleFileRepresentation.create
      @work.representations << @rep << rep2
      @work.save!

      @work.representations.should == [@rep, rep2]
      @rep.ie.should == @work
      rep2.ie.should == @work
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


      @rep.ie.should == @work
      rep2.ie.should == @work
      #@work.representations.should == [@rep, rep2]

    end
  end

  describe '#ordered_representations' do
    before :each do
      @work = Work.create(:title => "The title")
      @rep = OrderedRepresentation.create
    end

    it 'should be possible to define a relation from work, which can be viewed both ways' do
      @work.representations << @rep
      @work.save!

      @work.representations.should == [@rep]
      @rep.ie.should == @work
    end

    it 'should be possible to have two representations defined from work' do
      rep2 = OrderedRepresentation.create
      @work.representations << @rep << rep2
      @work.save!

      @work.representations.should == [@rep, rep2]
      @rep.ie.should == @work
      rep2.ie.should == @work
    end
  end
end
