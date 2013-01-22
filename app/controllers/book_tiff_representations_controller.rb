# -*- encoding : utf-8 -*-
class BookTiffRepresentationsController < ApplicationController
  load_and_authorize_resource
  def index
    @book_tiff_representations = BookTiffRepresentation.all
  end

  def show
    @book_tiff_representation = BookTiffRepresentation.find(params[:id])
  end

  def new
    @book_tiff_representation = BookTiffRepresentation.new
  end

  def edit
    @book_tiff_representation = BookTiffRepresentation.find(params[:id])
  end

  def create
    @book_tiff_representation = BookTiffRepresentation.new(params[:book_tiff_representation])

    if @book_tiff_representation.save
      file = BasicFile.new
      if file.add_file(params[:file_data])
        file.container = @book_tiff_representation
        file.save
        @book_tiff_representation.files << file
        @book_tiff_representation.save
      end
      redirect_to @book_tiff_representation, notice: 'Book tiff representation was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @book_tiff_representation = BookTiffRepresentation.find(params[:id])

    if @book_tiff_representation.update_attributes(params[:book_tiff_representation])
      redirect_to @book_tiff_representation, notice: 'Book tiff representation was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @book_tiff_representation = BookTiffRepresentation.find(params[:id])
    @book_tiff_representation.destroy

    redirect_to book_tiff_representations_url
  end
end
