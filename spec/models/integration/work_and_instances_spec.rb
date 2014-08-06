# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Work relationships' do
  describe '#single_file_instance' do
    before :each do
      @work = Work.create(:title => 'The title' + Time.now.nsec.to_s)
      @ins = SingleFileInstance.create
    end

    it 'should be possible to define a ordered relation from work, which can be viewed both ways' do
      @work.instances << @ins
      @work.save!

      @work.reload
      @work.has_ins?.should be_true

      @work.instances.should == [@ins]
      @ins.ie.should == @work
    end

    it 'should be possible to have two instances defined from work' do
      ins2 = SingleFileInstance.create
      @work.instances << @ins << ins2
      @work.save!

      @work.instances.should == [@ins, ins2]
      @ins.ie.should == @work
      ins2.ie.should == @work
    end

    it 'should be possible to have two instances defined from the instances' do
      @ins.ie = @work
      @ins.save!
      @ins.reload
      ins2 = SingleFileInstance.create
      ins2.ie = @work
      ins2.save!
      ins2.reload

      @work.reload


      @ins.ie.should == @work
      ins2.ie.should == @work
      #@work.instances.should == [@ins, ins2]

    end
  end

  describe '#ordered_instances' do
    before :each do
      @work = Work.create(:title => "The title")
      @ins = OrderedInstance.create
    end

    it 'should be possible to define a relation from work, which can be viewed both ways' do
      @work.instances << @ins
      @work.save!

      @work.reload
      @work.has_ins?.should be_true

      @work.instances.should == [@ins]
      @ins.ie.should == @work
    end

    it 'should be possible to have two instances defined from work' do
      ins2 = OrderedInstance.create
      @work.instances << @ins << ins2
      @work.save!

      @work.instances.should == [@ins, ins2]
      @ins.ie.should == @work
      ins2.ie.should == @work
    end
  end

end
