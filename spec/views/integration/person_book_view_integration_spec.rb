# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'relationship between book and people' do
  describe 'without any relationships' do
    before(:each) do
      @book = Book.create(:title => 'book title')
      @person = Person.create(:firstname => 'person firstname', :lastname => 'person lastname', :date_of_birth => Time.now.nsec.to_s)
    end
    describe 'book' do
      it 'should not contain any references' do
        visit book_path(@book)

        page.should have_content("Author")
        page.should have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
      end
    end

    describe 'person' do
      it 'should not contain any references' do
        visit person_path(@person)

        page.should have_content("No books authored by this person.")
        page.should have_content("No books are concerning this person.")
      end
    end
  end

  describe '#author' do
    describe 'book view' do
      before(:each) do
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain a single author relationship' do
        @book1.authors << @person1
        @book1.save!

        visit book_path(@book1)

        page.should_not have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should contain multiple author relationships' do
        @book1.authors << @person1
        @book1.authors << @person2
        @book1.save!

        visit book_path(@book1)

        page.should_not have_content("No author defined for this book.")
        page.should_not have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end
    end

    describe 'person view' do
      before(:each) do
        @book1 = Book.create(:title => 'book1 title')
        @book2 = Book.create(:title => 'book2 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain a single author relationship' do
        # author relationship is defined on book
        @book1.authors << @person1
        @book1.save!

        visit person_path(@person1)

        page.should_not have_content("No books authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@book2.get_title_for_display, :href => book_path(@book2) + '?locale=en').should be_false
      end

      it 'should contain multiple author relationships' do
        # author relationship is defined on book
        @book1.authors << @person1
        @book1.save!
        @book2.authors << @person1
        @book2.save!

        visit person_path(@person1)

        page.should_not have_content("No books authored by this person.")
        page.should have_content("No books are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@book2.get_title_for_display, :href => book_path(@book2) + '?locale=en').should be_true
      end
    end
  end

  describe '#is_concerned_by' do
    describe 'book view' do
      before(:each) do
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain a single description_of relationship' do
        @book1.people_concerned << @person1
        @book1.save!

        visit book_path(@book1)

        page.should have_content("No author defined for this book.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
      end

      it 'should contain multiple description_of relationships' do
        @book1.people_concerned << @person1
        @book1.people_concerned << @person2
        @book1.save!

        visit book_path(@book1)

        page.should have_content("No author defined for this book.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end
    end

    describe 'person view' do
      before(:each) do
        @book1 = Book.create(:title => 'book1 title')
        @book2 = Book.create(:title => 'book2 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain a single description_of relationship' do
        # author relationship is defined on book
        @book1.people_concerned << @person1
        @book1.save!

        visit person_path(@person1)

        page.should have_content("No books authored by this person.")
        page.should_not have_content("No books are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@book2.get_title_for_display, :href => book_path(@book2) + '?locale=en').should be_false
      end

      it 'should contain multiple author relationships' do
        # author relationship is defined on book
        @book1.people_concerned << @person1
        @book1.save!
        @book2.people_concerned << @person1
        @book2.save!

        visit person_path(@person1)

        page.should have_content("No books authored by this person.")
        page.should_not have_content("No books are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@book2.get_title_for_display, :href => book_path(@book2) + '?locale=en').should be_true
      end
    end
  end

  describe 'both author and is_concerned_by' do
    describe 'book view' do
      before(:each) do
        @book1 = Book.create(:title => 'book1 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
        @person2 = Person.create(:firstname => 'person2 firstname', :lastname => 'person2 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain both relationships' do
        @book1.people_concerned << @person1
        @book1.authors << @person2
        @book1.save!

        visit book_path(@book1)

        page.should_not have_content("No author defined for this book.")
        page.should have_content("Concerning")
        page.has_link?(@person1.name, :href => person_path(@person1) + '?locale=en').should be_true
        page.has_link?(@person2.name, :href => person_path(@person2) + '?locale=en').should be_true
      end
    end

    describe 'person view' do
      before(:each) do
        @book1 = Book.create(:title => 'book1 title')
        @book2 = Book.create(:title => 'book2 title')
        @person1 = Person.create(:firstname => 'person1 firstname', :lastname => 'person1 lastname', :date_of_birth => Time.now.nsec.to_s)
      end
      it 'should contain both relationships' do
        # author relationship is defined on book
        @book1.people_concerned << @person1
        @book1.save!
        @book2.authors << @person1
        @book2.save!

        visit person_path(@person1)

        page.should_not have_content("No books authored by this person.")
        page.should_not have_content("No books are concerning this person.")
        page.has_link?(@book1.get_title_for_display, :href => book_path(@book1) + '?locale=en').should be_true
        page.has_link?(@book2.get_title_for_display, :href => book_path(@book2) + '?locale=en').should be_true
      end
    end
  end

  after(:all) do
    Book.all.each { |b| b.delete }
    Person.all.each { |p| p.delete }
  end
end