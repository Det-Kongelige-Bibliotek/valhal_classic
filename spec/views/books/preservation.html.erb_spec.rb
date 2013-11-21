# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "books/preservation" do
  describe 'with capybara' do
    before(:each) do
      @book = Book.create!(title: 'test-title')
    end
    it 'should contain the default preservation metadata about the book.' do
      visit preservation_book_path(@book)

      page.has_text?(@book.preservation_profile)
      page.has_text?(@book.preservation_state)
      page.has_text?(@book.preservation_modify_date)
    end
  end
end