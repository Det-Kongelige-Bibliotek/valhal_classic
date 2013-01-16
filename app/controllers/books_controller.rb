# -*- encoding : utf-8 -*-
class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(params[:book])

    if @book.save
      if !params[:file].blank? && !params[:file][:tei_file].blank? || !params[:file][:tiff_file].blank?
        tei = BookTeiRepresentation.new
        tei.save!

        tiff = BookTiffRepresentation.new
        tiff.save!

        tei_file = BasicFile.new
        tei_file.add_file(params[:file][:tei_file])
        tei_file.container = tei
        tei_file.save!
        tei.files << tei_file

        tei.book = @book
        tei.save!

        params[:file][:tiff_file].each do |f|
          tiff_file = BasicFile.new
          tiff_file.add_file(f)
          puts f.original_filename
          tiff_file.container = tiff
          tiff_file.save!
          tiff.files << tiff_file
        end

        tiff.book = @book
        tiff.save!
      end
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update_attributes(params[:book])
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to books_url
  end
end
