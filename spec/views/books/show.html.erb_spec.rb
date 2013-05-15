# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "books/show" do
  describe 'default' do
    before(:each) do
      @book = assign(:book, stub_model(Book))
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
    end
  end

  describe 'relationship with person' do
    before(:each) do
      @book = Book.create(:title => 'The book title')
      @person = Person.create(:firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.new.to_i.to_s)
    end
    it 'should work without references' do
      render

      rendered.should contain("Author")
      rendered.should contain("No author defined for this book.")
      rendered.should_not contain("Description of")
    end

    it 'should contain a author relationship to person' do
      @book.authors << @person
      @book.save!

      render

      rendered.should contain("Author")
      rendered.should contain(@person.name)
      #rendered.should contain(person_path(@person))
      rendered.should_not contain("No author defined for this book.")
      rendered.should_not contain("Description of")
    end

  end
end
