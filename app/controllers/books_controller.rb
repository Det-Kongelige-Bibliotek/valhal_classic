# -*- encoding : utf-8 -*-
class BooksController < ApplicationController
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

  def create
    @book = Book.new(params[:book])

    if @book.save
      if !params[:file].blank? && !params[:file][:tei_file].blank? || !params[:file].blank? && !params[:file][:tiff_file].blank?

        #Create TEI representation of book using uploaded TEI file if a file was uploaded
        if !params[:file][:tei_file].blank?
          logger.debug "Creating a tei representation"
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

        #Create TIFF representation of book using uploaded TIFF file(s) if file(s) was uploaded
        if !params[:file][:tiff_file].blank?
          logger.debug "Creating a tiff representation"
          tiff = BookTiffRepresentation.new
          tiff.save!

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

        #Create METS Structmap for book using uploaded METS file if file was uploaded
        if !params[:file][:tiff_file].blank? && !params[:file][:structmap_file].blank?
          uploaded_struct_map_file = params[:file][:structmap_file]
          processed_structmap_file = write_tiff_uuids_to_structmap(uploaded_struct_map_file.tempfile, tiff.files)

          struct_map_file = BasicFile.new
          uploaded_struct_map_file.tempfile = processed_structmap_file
          struct_map_file.add_file(uploaded_struct_map_file)
          tiff.files << struct_map_file

          tiff.book = @book
          tiff.save!
        end

      end
      # add the authors to the book
      if !params[:person].blank? && !params[:person][:id].blank?
        params[:person][:id].each do |author_pid|
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
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update_attributes(params[:book])
      if !params[:file].blank? && !params[:file][:tei_file].blank? || !params[:file].blank? && !params[:file][:tiff_file].blank?

        #Create TEI representation of book using uploaded TEI file if a file was uploaded
        if !params[:file][:tei_file].blank?
          logger.debug "Creating a tei representation"
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

        #Create TIFF representation of book using uploaded TIFF file(s) if file(s) was uploaded
        if !params[:file][:tiff_file].blank?
          logger.debug "Creating a tiff representation"
          tiff = BookTiffRepresentation.new
          tiff.save!

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

        #Create METS Structmap for book using uploaded METS file if file was uploaded
        if !params[:file][:tiff_file].blank? && !params[:file][:structmap_file].blank?
          uploaded_struct_map_file = params[:file][:structmap_file]
          processed_structmap_file = write_tiff_uuids_to_structmap(uploaded_struct_map_file.tempfile, tiff.files)

          struct_map_file = BasicFile.new
          uploaded_struct_map_file.tempfile = processed_structmap_file
          struct_map_file.add_file(uploaded_struct_map_file)
          tiff.files << struct_map_file

          tiff.book = @book
          tiff.save!
        end

      end
      # add the authors to the book
      if !params[:person].blank? && !params[:person][:id].blank?
        puts params
        puts "Person arguments "
        # Remove any existing relationships
        @book.authors.clear
        #Add a new relationship for each author
        params[:person][:id].each do |author_pid|
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

  #Take the UUIDs of the uploaded tiff files and write them to the structmap replacing the original tiff file names
  private
  # @param [Object] structmap_file
  # @param [Object] tiff_basic_files
  # @param [Object] original_filename
  def write_tiff_uuids_to_structmap(structmap_file, tiff_basic_files)

    #Put the UUIDs for each tif file in a hash using the original filename as the key for each UUID
    tiffs_hash = Hash.new

    tiff_basic_files.each do |tiff_basic_file|
      if tiff_basic_file.original_filename.end_with?(".tif")
        tiffs_hash[tiff_basic_file.original_filename] = tiff_basic_file.uuid
      end
    end

    #now open the structmap file and search and replace original filenames with UUIDs
    structmap_xml = structmap_file.read

    tiffs_hash.each_key do |key|
      structmap_xml = structmap_xml.gsub(key, tiffs_hash[key])
    end

    replaced_file = Tempfile.new(structmap_file.path, "wb")
    replaced_file.write(structmap_xml)
    replaced_file.close()
    replaced_file.open()

    return replaced_file
  end
end
