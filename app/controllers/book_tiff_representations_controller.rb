# -*- encoding : utf-8 -*-
class BookTiffRepresentationsController < ApplicationController
  require 'zip/zip'
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
      if file.add_file(params[:file][:tiff_file])
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

  def download_all
    begin
      @book_tiff_representation = BookTiffRepresentation.find(params[:id])
      file_name = "tiffs-#{params[:id]}.zip"
      t = Tempfile.new("temp-tiff-zip-#{params[:id]}-#{Time.now}")
      Zip::ZipOutputStream.open(t.path) do |z|
        @book_tiff_representation.files.each do |f|
          #add file to zip file
          z.put_next_entry(f.original_filename)
          z.write f.content.content
        end
      end

      send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => file_name
      t.close
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The file you requested could not be found in Fedora!  Please contact your system administrator'
      logger.error obj_not_found.to_s
      redirect_to :back
    rescue StandardError => standard_error
      flash[:error] = 'An error has occurred.  Please contact your system administrator'
      logger.error standard_error.to_s
      redirect_to :back
    end
  end
end
