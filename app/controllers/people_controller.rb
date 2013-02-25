# -*- encoding : utf-8 -*-
class PeopleController < ApplicationController
  load_and_authorize_resource
  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def show_image
    @person = Person.find(params[:id])
    image_content = @person.person_image_representation.last.person_image_files.last.content.content
    original_filename = @person.person_image_representation.last.person_image_files.last.original_filename
    mime_type = @person.person_image_representation.last.person_image_files.last.mime_type
    send_data(image_content, {:filename => original_filename, :type => mime_type, :disposition => 'inline'})
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def create

    logger.debug 'Validating parameters...'
    if (!params[:portrait].blank? && !params[:portrait][:portrait_file].blank?)  && (!params[:portrait][:portrait_file].content_type.start_with? "image/")
      logger.error "Invalid file type uploaded: " + params[:portrait][:portrait_file].content_type.to_s
      @person.errors.add(:portrait_file, " - You tried to upload a non-image file, please select a valid image file")
      render action: "new"
    end
    logger.debug 'Validation successful'

    logger.debug 'Entered the create logic...'
    @person = Person.new(params[:person])
    logger.debug 'Create new person successfully'

    if @person.save!
      logger.debug 'Saved new person successfully'
      if (!params[:portrait].blank?) && (params[:portrait][:portrait_file].blank?)
        redirect_to @person, notice: 'Person was successfully created.'
      else
        #validate the file mime type
        logger.debug 'Person image file not blank, validating file...'
        if (!params[:portrait].blank?) && (params[:portrait][:portrait_file].content_type.start_with? "image/")
          logger.debug "Valid image file uploaded, creating image related objects"
          person_image_representation = PersonImageRepresentation.new
          person_image_representation.save!

          person_image_file = BasicFile.new
          person_image_file.add_file(params[:portrait][:portrait_file])
          person_image_file.container = person_image_representation
          person_image_file.save!
          person_image_representation.person_image_files << person_image_file

          person_image_representation.person = @person
          person_image_representation.save!

          @person.person_image_representation << person_image_representation

          if @person.save!
            redirect_to @person, notice: 'Person was successfully created.'
          else
            render action: "new"
          end
        else
          redirect_to @person, notice: 'Person was successfully created.'
        end
      end
    else
      render action: "new"
    end
  end

  def update
    @person = Person.find(params[:id])

    if @person.update_attributes(params[:person])

      unless params[:person_image_file].blank?

        if params[:person_image_file].content_type.start_with? "image/"
          person_image_representation = PersonImageRepresentation.find(@person.person_image_representation.first.pid)
          person_image_representation.person_image_files.delete_at(0)
          person_image_representation.save!

          @person.person_image_representation.delete_at(0)
          @person.save!

          person_image_representation = PersonImageRepresentation.new
          person_image_representation.save!
          person_image_file = BasicFile.new
          person_image_file.add_file(params[:person_image_file])
          person_image_file.container = person_image_representation
          person_image_file.save!
          person_image_representation.person_image_files << person_image_file

          person_image_representation.person = @person
          person_image_representation.save!

          if @person.save!
            redirect_to @person, notice: 'Person was successfully updated.'
          end
        else
          @person.errors.add(:person_image_file, " - You tried to upload a non-image file, please select a valid image file")
          render action: "edit"
        end
      else
        redirect_to @person, notice: 'Person was successfully updated.'
      end
    else
      render action: "edit"
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    redirect_to people_url
  end
end
