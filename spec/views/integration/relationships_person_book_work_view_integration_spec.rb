# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'relationships for people, book and work' do
  describe '#author' do
    describe 'only for book' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @book1.authors << @person1
        @book1.save!
      end
      it 'should be defined in the book view' do
        visit book_path(@book1)

        page.should_not have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should not be defined in the work view' do
        visit work_path(@work1)

        page.should have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_false
      end

      it 'should be defined in the person view' do
        visit person_path(@person1)

        page.should_not have_content("No books authored by this person.")
        page.should have_content("No works authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_false
      end
    end

    describe 'only for work' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @work1.authors << @person1
        @work1.save!
      end
      it 'should not be defined in the book view' do
        visit book_path(@book1)

        page.should have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_false
      end

      it 'should be defined in the work view' do
        visit work_path(@work1)

        page.should_not have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should be defined in the person view' do
        visit person_path(@person1)

        page.should have_content("No books authored by this person.")
        page.should_not have_content("No works authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_false
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end
    end

    describe 'both for work and book' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @book1.authors << @person1
        @book1.save!
        @work1.authors << @person1
        @work1.save!
      end
      it 'should be defined in the book view' do
        visit book_path(@book1)

        page.should_not have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should be defined in the work view' do
        visit work_path(@work1)

        page.should_not have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should be defined in the person view' do
        visit person_path(@person1)

        page.should_not have_content("No books authored by this person.")
        page.should_not have_content("No works authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end
    end
  end

  describe '#is_concerned_by' do
    describe 'only for book' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @book1.people_concerned << @person1
        @book1.save!
      end
      it 'should be defined in the book view' do
        visit book_path(@book1)

        page.should have_content("No author defined for this book.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should not be defined in the work view' do
        visit work_path(@work1)

        page.should have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_false
      end

      it 'should be defined in the person view' do
        visit person_path(@person1)

        page.should have_content("No books authored by this person.")
        page.should have_content("No works authored by this person.")
        page.should_not have_content("No books are concerning this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_false
      end
    end

    describe 'only for work' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @work1.people_concerned << @person1
        @work1.save!
      end
      it 'should not be defined in the book view' do
        visit book_path(@book1)

        page.should have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_false
      end

      it 'should be defined in the work view' do
        visit work_path(@work1)

        page.should have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should be defined in the person view' do
        visit person_path(@person1)

        page.should have_content("No books authored by this person.")
        page.should have_content("No works authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_false
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end
    end

    describe 'both for work and book' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @book1.people_concerned << @person1
        @book1.save!
        @work1.people_concerned << @person1
        @work1.save!
      end
      it 'should be defined in the book view' do
        visit book_path(@book1)

        page.should have_content("No author defined for this book.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should be defined in the work view' do
        visit work_path(@work1)

        page.should have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should be defined in the person view' do
        visit person_path(@person1)

        page.should have_content("No books authored by this person.")
        page.should have_content("No works authored by this person.")
        page.should_not have_content("No books are concerning this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end
    end
  end

  describe 'both #author and #description_of' do
    describe 'regarding one book and two people' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)

        @book1.authors << @person1
        @book1.people_concerned << @person2
        @book1.save!
      end
      it 'should both be defined in the book view' do
        visit book_path(@book1)

        page.should_not have_content("No author defined for this book.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end

      it 'should not be defined in the work view' do
        visit work_path(@work1)

        page.should have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_false
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_false
      end

      it 'should author be defined in person1 view' do
        visit person_path(@person1)

        page.should_not have_content("No books authored by this person.")
        page.should have_content("No works authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_false
      end

      it 'should description_of be defined in person2 view' do
        visit person_path(@person2)

        page.should have_content("No books authored by this person.")
        page.should have_content("No works authored by this person.")
        page.should_not have_content("No books are concerning this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_false
      end
    end

    describe 'regarding one work and two people' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)

        @work1.authors << @person1
        @work1.people_concerned << @person2
        @work1.save!
      end

      it 'should not be defined in the book view' do
        visit book_path(@book1)

        page.should have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_false
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_false
      end

      it 'should both be defined in the work view' do
        visit work_path(@work1)

        page.should_not have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end

      it 'should author be defined in person1 view' do
        visit person_path(@person1)

        page.should have_content("No books authored by this person.")
        page.should_not have_content("No works authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.should have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_false
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end

      it 'should description_of be defined in person2 view' do
        visit person_path(@person2)

        page.should have_content("No books authored by this person.")
        page.should have_content("No works authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_false
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
      end
    end

    describe 'regarding one person, two books, two works and all relationships' do
      before(:all) do
        @work1 = Work.create(:title => 'work1 title')
        @work2 = Work.create(:title => 'work2 title')
        @book1 = Book.create(:title => 'book1 title')
        @book2 = Book.create(:title => 'book2 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)

        @book1.authors << @person1
        @book1.save!
        @book2.people_concerned << @person1
        @book2.save!

        @work1.authors << @person1
        @work1.save!
        @work2.people_concerned << @person1
        @work2.save!
      end

      it 'should author be defined in the book1 view' do
        visit book_path(@book1)

        page.should_not have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should description_of be defined in the book2 view' do
        visit book_path(@book2)

        page.should have_content("No author defined for this book.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end


      it 'should author be defined in the work1 view' do
        visit work_path(@work1)

        page.should_not have_content("No author defined for this work.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should description_of be defined in the work2 view' do
        visit work_path(@work2)

        page.should have_content("No author defined for this work.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should person1 have all the relationships defined in the view' do
        visit person_path(@person1)

        page.should_not have_content("No books authored by this person.")
        page.should_not have_content("No works authored by this person.")
        page.should_not have_content("No books are concerning this person.")
        page.should_not have_content("No works are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@book2.get_title_for_display, :href => book_path(@book2) + '?locale=en').should be_true
        page.has_link?(@work1.get_title_for_display, :href => work_path(@work1) + '?locale=en').should be_true
        page.has_link?(@work2.get_title_for_display, :href => work_path(@work2) + '?locale=en').should be_true
      end
    end
  end

  after(:all) do
    Work.all.each { |w| w.delete }
    Book.all.each { |b| b.delete }
    Person.all.each { |p| p.delete }
  end
end