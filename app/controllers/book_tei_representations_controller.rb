# -*- encoding : utf-8 -*-
class BookTeiRepresentationsController < ApplicationController
  # GET /book_tei_representations
  # GET /book_tei_representations.json
  def index
    @book_tei_representations = BookTeiRepresentation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @book_tei_representations }
    end
  end

  # GET /book_tei_representations/1
  # GET /book_tei_representations/1.json
  def show
    @book_tei_representation = BookTeiRepresentation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book_tei_representation }
    end
  end

  # GET /book_tei_representations/new
  # GET /book_tei_representations/new.json
  def new
    @book_tei_representation = BookTeiRepresentation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book_tei_representation }
    end
  end

  # GET /book_tei_representations/1/edit
  def edit
    @book_tei_representation = BookTeiRepresentation.find(params[:id])
  end

  # POST /book_tei_representations
  # POST /book_tei_representations.json
  def create
    @book_tei_representation = BookTeiRepresentation.new(params[:book_tei_representation])


    respond_to do |format|
      if @book_tei_representation.save
        file = BasicFile.new
        if file.add_file(params[:file_data])
          file.container = @book_tei_representation
          file.save
          @book_tei_representation.files << file
          @book_tei_representation.save
        end
        format.html { redirect_to @book_tei_representation, notice: 'Book tei representation was successfully created.' }
        format.json { render json: @book_tei_representation, status: :created, location: @book_tei_representation }
      else
        format.html { render action: "new" }
        format.json { render json: @book_tei_representation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /book_tei_representations/1
  # PUT /book_tei_representations/1.json
  def update
    @book_tei_representation = BookTeiRepresentation.find(params[:id])

    respond_to do |format|
      if @book_tei_representation.update_attributes(params[:book_tei_representation])
        format.html { redirect_to @book_tei_representation, notice: 'Book tei representation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book_tei_representation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_tei_representations/1
  # DELETE /book_tei_representations/1.json
  def destroy
    @book_tei_representation = BookTeiRepresentation.find(params[:id])
    @book_tei_representation.destroy

    respond_to do |format|
      format.html { redirect_to book_tei_representations_url }
      format.json { head :no_content }
    end
  end
end
