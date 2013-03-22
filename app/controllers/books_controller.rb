# -*- encoding : utf-8 -*-
class BooksController < ApplicationController
  include Wicked::Wizard
  include BooksHelper

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

  def validate_book(params)
    #Validate form params
    logger.debug 'Validating parameters...'
    if (!params[:file].blank? && !params[:file][:tiff_file].blank?)  && (!params[:file][:tiff_file].first.content_type.start_with? "image/tiff")
      logger.error "Invalid file type uploaded: " + params[:file][:tiff_file].first.content_type.to_s
      @book.errors.add(:fileupload, " - You tried to upload a non TIFF image file, please select a valid TIFF image file")
    end

    if (!params[:file].blank? && !params[:file][:tei_file].blank?)  && (!params[:file][:tei_file].content_type.start_with? "text/xml")
      logger.error "Invalid file type uploaded: " + params[:file][:tei_file].content_type.to_s
      @book.errors.add(:file_tei_file, " - You tried to upload a non XML file, please select a valid XML file")
    end

    if (!params[:file].blank? && !params[:file][:structmap_file].blank?)  && (!params[:file][:structmap_file].content_type.start_with? "text/xml")
      logger.error "Invalid file type uploaded: " + params[:file][:structmap_file].content_type.to_s
      @book.errors.add(:file_structmap_file, " - You tried to upload a non XML file, please select a valid XML file")
    end
    logger.debug 'Validation finished'
  end

  def create_structmap
    logger.debug 'Creating structmap...'
    logger.debug params.to_s
    if params[:structmap_file_order].blank?
      redirect_to @book, notice: 'Book was successfully created.'
    else
      #generate structmap file and add to the TIFF representation
      generate_structmap(params[:structmap_file_order], @book.tif.first)
      redirect_to @book, notice: 'Book was successfully created.'
    end
  end

  def create

    validate_book(params)
    if @book.errors.size > 0
      logger.debug "#{@book.errors.size.to_s} Validation errors found, returning to form"
      render action: "new"
      return
    end

    #Validation passed begin processing parameters
    @book = Book.new(params[:book])

    if @book.save

      # add the authors to the book
      if !params[:person].blank? && !params[:person][:id].blank?
        add_authors(params[:person][:id])
      end

      #Create TEI representation of book using uploaded TEI file if a file was uploaded
      if !params[:file].blank? && !params[:file][:tei_file].blank?
        logger.debug "Creating a tei representation"
        add_tei_representation
      end

      #Create TIFF representation of book using uploaded TIFF file(s) if file(s) was uploaded
      if !params[:file].blank? && !params[:file][:tiff_file].blank?
        logger.debug "Creating a tiff representation"
        add_tiff_representation
        render_wizard
      else
        redirect_to @book, notice: 'Book was successfully created.'
      end
    else
      render action: "new"
    end
  end

  def update
    @book = Book.find(params[:id])

    validate_book(params)
    if @book.errors.size > 0
      logger.debug "#{@book.errors.size.to_s} Validation errors found, returning to form"
      render action: "edit"
      return
    end

    if @book.update_attributes(params[:book])
      if !params[:file].blank? && !params[:file][:tei_file].blank? || !params[:file].blank? && !params[:file][:tiff_file].blank?

      #Create TEI representation of book using uploaded TEI file if a file was uploaded
      if !params[:file].blank? && !params[:file][:tei_file].blank?
        logger.debug "Creating a tei representation"
          add_tei_representation
      end

      #Create TIFF representation of book using uploaded TIFF file(s) if file(s) was uploaded
      if !params[:file].blank? &&!params[:file][:tiff_file].blank?
        logger.debug "Creating a tiff representation"
          add_tiff_representation
        end

      end
      # add the authors to the book
      if !params[:person].blank? && !params[:person][:id].blank?
        # Remove any existing relationships
        @book.authors.clear
        # add new persons as authors
        add_authors(params[:person][:id])
      end
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

  # creates the tei representation with the tei file
  private
  def add_tei_representation
    tei = BookTeiRepresentation.new(params[:tei])
    tei.save!

    tei_file = BasicFile.new
    tei_file.add_file(params[:file][:tei_file])
    tei_file.container = tei
    tei_file.save!
    tei.files << tei_file

    tei.book = @book
    tei.save!
  end

  # creates the tiff representation and adds the tiff images with the structmap
  private
  def add_tiff_representation
    tiff = BookTiffRepresentation.new(params[:tiff])
    tiff.save!

    params[:file][:tiff_file].each do |f|
      tiff_file = TiffFile.new
      tiff_file.add_file(f)
      logger.debug f.original_filename
      tiff_file.container = tiff
      tiff_file.save!
      tiff.files << tiff_file
    end

    #Create METS Structmap for book using uploaded METS file if file was uploaded
    #if !params[:file][:structmap_file].blank?
    #  add_structmap(tiff, params[:file][:structmap_file])
    #end

    tiff.book = @book
    tiff.save!
    @book.save!
  end

  # adds the person defined in the params as authors
  private
  def add_authors(ids)
    # add the authors to the book
    ids.each do |author_pid|
      if author_pid && !author_pid.empty?
        author = Person.find(author_pid)
        @book.authors << author

        # TODO: Relationship should not be defined both ways.
        author.authored_books << @book
        author.save!
      end
    end
    @book.save!
  end
end
