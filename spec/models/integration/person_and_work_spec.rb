# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Person and Work' do
  describe '#author relationship' do
    before :each do
      @person = Person.create(:firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.new.to_i.to_s)
      @work = Work.create(:title => 'work title')
    end

    it 'should be possible to defined the relationship from the person' do
      @person.authored_manifestations << @work
      @person.save!

      @person.authored_manifestations.should == [@work]
      @work.authors.should == [@person]
    end

    it 'should be possible to defined the relationship from the work' do
      @work.authors << @person
      @work.save!

      @work.authors.should == [@person]
      @person.authored_manifestations.should == [@work]
    end
  end

  describe '#described relationship' do
    before :each do
      @person = Person.create(:firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.new.to_i.to_s)
      @work = Work.create(:title => 'work title')
    end

    it 'should be possible to defined the relationship from the person' do
      @person.describing_manifestations << @work
      @person.save!

      @person.describing_manifestations.should == [@work]
      @work.people_described.should == [@person]
    end

    it 'should be possible to defined the relationship from the work' do
      @work.people_described << @person
      @work.save!

      @work.people_described.should == [@person]
      @person.describing_manifestations.should == [@work]
    end
  end

  after :all do
    Person.all.each { |p| p.delete }
    Work.all.each { |w| w.delete }
  end
end
