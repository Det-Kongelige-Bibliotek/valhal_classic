# -*- encoding : utf-8 -*-
class BookTeiRepresentationsController < ApplicationController
  def index
    @book_tei_representations = BookTeiRepresentation.all
  end

  def show
    @book_tei_representation = BookTeiRepresentation.find(params[:id])
  end

  def new
    @book_tei_representation = BookTeiRepresentation.new
  end

  def edit
    @book_tei_representation = BookTeiRepresentation.find(params[:id])
  end

  def create
    @book_tei_representation = BookTeiRepresentation.new(params[:book_tei_representation])

    if @book_tei_representation.save
      file = BasicFile.new
      if file.add_file(params[:file_data])
        file.container = @book_tei_representation
        file.save
        @book_tei_representation.files << file
        @book_tei_representation.save
      end
      redirect_to @book_tei_representation, notice: 'Book tei representation was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @book_tei_representation = BookTeiRepresentation.find(params[:id])

    if @book_tei_representation.update_attributes(params[:book_tei_representation])
      redirect_to @book_tei_representation, notice: 'Book tei representation was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @book_tei_representation = BookTeiRepresentation.find(params[:id])
    @book_tei_representation.destroy

    redirect_to book_tei_representations_url
  end
end
