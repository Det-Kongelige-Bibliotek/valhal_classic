# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'relationship between work and people' do
  describe 'without any relationships' do
    before(:each) do
      @work = Work.create(:title => 'work title')
      @person = Person.create(:firstname => 'person firstname', :lastname => 'person lastname', :date_of_birth => Time.now.nsec.to_s)
    end
    describe 'work' do
      it 'should not contain any references' do
        visit work_path(@work)

        page.should have_content("Author")
        page.should have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
      end
    end

    describe 'person' do
      it 'should not contain any references' do
        visit person_path(@person)

        page.should have_content("No works authored by this person.")
        page.should have_content("No works are concerning this person.")
      end
    end
  end

  describe '#author' do
    describe 'work view' do
      before(:each) do
        @work1 = Work.create(:title => 'work1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain a single author relationship' do
        @work1.authors << @person1
        @work1.save!

        visit work_path(@work1)

        page.should_not have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should contain multiple author relationships' do
        @work1.authors << @person1
        @work1.authors << @person2
        @work1.save!

        visit work_path(@work1)

        page.should_not have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end
    end

    describe 'person view' do
      before(:each) do
        #pending "Figure out why this causes issues!!"
        @work1 = Work.create(:title => 'work1 title')
        @work2 = Work.create(:title => 'work2 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain a single author relationship' do
        # author relationship is defined on work
        @work1.authors << @person1
        @work1.save!

        visit person_path(@person1)

        page.should_not have_content("No works authored by this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
        page.has_link?(@work2.get_title_for_display, :href => work_path(@work2) + '?locale=en').should be_false
      end

      it 'should contain multiple author relationships' do
        # author relationship is defined on work
        @work1.authors << @person1
        @work1.save!
        @work2.authors << @person1
        @work2.save!

        visit person_path(@person1)

        page.should_not have_content("No works authored by this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
        page.has_link?(@work2.get_title_for_display, :href => work_path(@work2) + '?locale=en').should be_true
      end
    end
  end

  describe '#is_concerned_by' do
    describe 'work view' do
      before(:each) do
        @work1 = Work.create(:title => 'work1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain a single description_of relationship' do
        @work1.people_concerned << @person1
        @work1.save!

        visit work_path(@work1)

        page.should have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should contain multiple description_of relationships' do
        @work1.people_concerned << @person1
        @work1.people_concerned << @person2
        @work1.save!

        visit work_path(@work1)

        page.should have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end
    end

    describe 'person view' do
      before(:each) do
        @work1 = Work.create(:title => 'work1 title')
        @work2 = Work.create(:title => 'work2 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain a single description_of relationship' do
        # author relationship is defined on work
        @work1.people_concerned << @person1
        @work1.save!

        visit person_path(@person1)

        page.should have_content("No works authored by this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
        page.has_link?(@work2.get_title_for_display, :href => work_path(@work2) + '?locale=en').should be_false
      end

      it 'should contain multiple author relationships' do
        # author relationship is defined on work
        @work1.people_concerned << @person1
        @work1.save!
        @work2.people_concerned << @person1
        @work2.save!

        visit person_path(@person1)

        page.should have_content("No works authored by this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
        page.has_link?(@work2.get_title_for_display, :href => work_path(@work2) + '?locale=en').should be_true
      end
    end
  end

  describe ' both author and is_concerned_by' do
    describe 'work view' do
      before(:each) do
        @work1 = Work.create(:title => 'work1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain both relationships' do
        @work1.people_concerned << @person1
        @work1.authors << @person2
        @work1.save!

        visit work_path(@work1)

        page.should_not have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end
    end

    describe 'person view' do
      before(:each) do
        @work1 = Work.create(:title => 'work1 title')
        @work2 = Work.create(:title => 'work2 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain both relationships' do
        # author relationship is defined on work
        @work1.people_concerned << @person1
        @work1.save!
        @work2.authors << @person1
        @work2.save!

        visit person_path(@person1)

        page.should_not have_content("No works authored by this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
        page.has_link?(@work2.get_title_for_display, :href => work_path(@work2) + '?locale=en').should be_true
      end
    end
  end

  after(:all) do
    Work.all.each { |w| w.delete }
    Person.all.each { |p| p.delete }
  end
end