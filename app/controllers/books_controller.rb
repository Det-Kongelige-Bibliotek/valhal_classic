# -*- encoding : utf-8 -*-
class BooksController < ApplicationController
  include Wicked::Wizard
  include ManifestationsHelper
  include PreservationHelper
  include MqHelper

  steps :sort_tiff_files

  load_and_authorize_resource
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

  def create_structmap
    logger.debug 'Creating structmap...'
    logger.debug params.to_s
    if params[:structmap_file_order].blank?
      logger.warn 'Cannot generate structmap, when no file_order is given.'
      redirect_to @book, notice: 'Book was successfully created.'
    else
      create_structmap_for_representation(params[:structmap_file_order], @book.ordered_reps.last)
      redirect_to @book, notice: 'Book was successfully created.'
    end
  end

  def create
    validate_book(params)
    if @book.errors.size > 0
      logger.debug "#{@book.errors.size.to_s} Validation errors found, returning to form"
      render action: 'new'
      return
    end

    #Validation passed begin processing parameters
    @book = Book.new(params[:book])
    handle_representation_parameters

    respond_to do |format|
      if @book.save
        format.html { redirect_to show_person_book_path @book }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_person
    @book = Book.find(params[:id])
    handle_person_relationship_parameters
    if @book.save
      redirect_to show_metadata_book_path @book
    else
      render action: 'update_person'
    end
  end

  def update_metadata
    @book = Book.find(params[:id])
    if @book.update_attributes(params[:book])
      redirect_to show_file_book_path @book
    else
      render action: 'update_metadata'
    end
  end

  def save_edit
    @book = Book.find(params[:id])
    if @book.update_attributes(params[:book])
      handle_person_relationship_parameters
      redirect_to show_file_book_path @book
    else
      render action: 'edit'
    end
  end

  def update_file
    validate_book(params)
    if @book.errors.size > 0
      logger.debug "#{@book.errors.size.to_s} Validation errors found, returning to last screen"
      @book = Book.find(params[:id])
      render action: 'show_file'
    else
      @book = Book.find(params[:id])
      handle_representation_parameters
      if !params[:file].blank? && !params[:file][:tiff_file].blank?
        render action: 'sort_tiff_files'
      else
        redirect_to @book, notice: 'Book was successfully created.'
      end
    end
  end

  def finish_book_with_structmap
    create_structmap_for_representation(params['structmap_file_order'], @book.ordered_reps.last)
    redirect_to @book, notice: 'Book was successfully created.'
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to books_url
  end

  # Updates the preservation settings.
  def update_preservation
    update_preservation_profile_from_controller(params, Book.find(params[:id]))
  end

  private
  # Creates the relationships to people in the parameters.
  def handle_person_relationship_parameters
    # add the authors to the book
    if !params[:person].blank? && !params[:person][:id].blank?
      # add new persons as authors
      set_authors(params[:person][:id], @book)
    end
    # add the people concerned by the book
    if !params[:person_concerned].blank? && !params[:person_concerned][:id].blank?
      @book.clear_concerned_people
      # add new concerned people
      set_concerned_people(params[:person_concerned][:id], @book)
    end
  end

  # Creates representations from the files in the parameters.
  def handle_representation_parameters
    #Create TEI representation of book using uploaded TEI file if a file was uploaded
    if !params[:file].blank? && !params[:file][:tei_file].blank?
      logger.debug 'Creating a tei representation'

      # If the label for the representation has not been defined, then it is set to 'TEI representation'.
      if params[:representation_metadata].blank? || params[:representation_metadata][:label].blank?
        add_single_tei_rep(params[:tei_metadata], params[:file][:tei_file], {:label => 'TEI representation'}, @book)
      else
        add_single_tei_rep(params[:tei_metadata], params[:file][:tei_file], params[:representation_metadata], @book)
      end
    end

    #Create TIFF representation of book using uploaded TIFF file(s) if file(s) was uploaded
    if !params[:file].blank? && !params[:file][:tiff_file].blank?
      logger.debug 'Creating a tiff representation'
      add_tiff_order_rep(params[:file][:tiff_file], params[:tiff], @book)
    end
  end

  def validate_book(params)
    #Validate form params
    logger.debug 'Validating parameters...'
    if (!params[:file].blank? && !params[:file][:tiff_file].blank?)  && (!params[:file][:tiff_file].first.content_type.start_with? 'image/tiff')
      logger.error 'Invalid file type uploaded: ' + params[:file][:tiff_file].first.content_type.to_s
      @book.errors.add(:fileupload, ' - You tried to upload a non TIFF image file, please select a valid TIFF image file')
    end

    if (!params[:file].blank? && !params[:file][:tei_file].blank?)  && (!params[:file][:tei_file].content_type.start_with? 'text/xml')
      logger.error 'Invalid file type uploaded: ' + params[:file][:tei_file].content_type.to_s
      @book.errors.add(:file_tei_file, ' - You tried to upload a non XML file, please select a valid XML file')
    end

    if (!params[:file].blank? && !params[:file][:structmap_file].blank?)  && (!params[:file][:structmap_file].content_type.start_with? 'text/xml')
      logger.error 'Invalid file type uploaded: ' + params[:file][:structmap_file].content_type.to_s
      @book.errors.add(:file_structmap_file, ' - You tried to upload a non XML file, please select a valid XML file')
    end
    logger.debug 'Validation finished'
  end
end
