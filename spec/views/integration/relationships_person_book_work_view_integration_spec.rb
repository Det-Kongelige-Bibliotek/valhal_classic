# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'relationships for people and works' do
  describe '#author' do
    describe 'only for work' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @work1.authors << @person1
        @work1.save!
      end

      it 'should be defined in the work view' do
        visit "works/#{@work1.id}"

        page.should_not have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should be defined in the person view' do
        visit "people/#{@person1.id}"

        page.should_not have_content("No works authored by this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end
    end
  end

  describe '#is_concerned_by' do
    describe 'only for work' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @work1.people_concerned << @person1
        @work1.save!
      end

      it 'should be defined in the work view' do
        visit "works/#{@work1.id}"

        page.should have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should be defined in the person view' do
        visit "people/#{@person1.id}"

        page.should have_content("No works authored by this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end
    end
  end

  describe 'both #author and #description_of' do
    describe 'regarding one work and two people' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)

        @work1.authors << @person1
        @work1.people_concerned << @person2
        @work1.save!
      end

      it 'should both be defined in the work view' do
        visit "works/#{@work1.id}"

        page.should_not have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end

      it 'should author be defined in person1 view' do
        visit "people/#{@person1.id}"

        page.should_not have_content("No works authored by this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end

      it 'should description_of be defined in person2 view' do
        visit "people/#{@person2.id}"

        page.should have_content("No works authored by this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end
    end

      it 'should author be defined in the work1 view' do
        visit "works/#{@work1.id}"

        page.should_not have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should description_of be defined in the work2 view' do
        visit "works/#{@work2.id}"

        page.should have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should person1 have all the relationships defined in the view' do
        visit "people/#{@person1.id}"

        page.should_not have_content("No works authored by this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
        page.has_link?(@work2.get_title_for_display, :href => work_path(@work2) + '?locale=en').should be_true
      end
    end

  after(:all) do
    Work.all.each { |w| w.delete }
    Person.all.each { |p| p.delete }
  end
end