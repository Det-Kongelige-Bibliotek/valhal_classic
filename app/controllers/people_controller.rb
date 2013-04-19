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
    if @person.person_image_representation.any?
      image_url(@person.person_image_representation.last)
    end
  end

  def image_url(representation = nil)
    if representation.nil?
      representation = Person.find(params[:id]).person_image_representation.last
    end

    image_content = representation.files.last.content.content
    original_filename = representation.files.last.original_filename
    mime_type = representation.files.last.mime_type
    send_data(image_content, {:filename => original_filename, :type => mime_type, :disposition => 'inline'})
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def validate_person(params)
    #Validate form params
    logger.debug 'Validating parameters...'
    if (!params[:portrait].blank? && !params[:portrait][:portrait_file].blank?)  && (!params[:portrait][:portrait_file].content_type.start_with? "image/")
      logger.error "Invalid file type uploaded: " + params[:portrait][:portrait_file].content_type.to_s
      @person.errors.add(:portrait_file, " - You tried to upload a non-image file, please select a valid image file")
    end
    logger.debug 'Validation finished'
  end

  # if there is an image file do all the image creation and add them to the person
  def add_portrait(params)
    if (!params[:portrait].blank?) && (params[:portrait][:portrait_file].content_type.start_with? "image/")
      logger.debug "Valid image file uploaded, creating image related objects"
      person_representation = DefaultRepresentation.new(params[:portrait_metadata])
      person_image_file = BasicFile.new
      person_image_file.add_file(params[:portrait][:portrait_file])
      person_representation.files << person_image_file

      person_representation.ie = @person
      person_representation.save!
    end
  end

  def create
    #validate the parameters posted
    validate_person(params)
    if @person.errors.size > 0
      logger.debug "#{@person.errors.size.to_s} Validation errors found, returning to form"
      render action: "new"
      return
    end

    #create a person object and save it so component parts can be linked to it
    @person = Person.new(params[:person])
    if @person.save
      logger.debug 'Created new person successfully'

      #add portrait (if any)
      add_portrait(params)

      #finally save the person again
      logger.debug '@person.errors.size = ' + @person.errors.size.to_s
      @person.save!

      logger.debug 'Saved new person successfully'
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render action: "new"
    end
  end

  def update

    #validate the parameters posted
    validate_person(params)
    if @person.errors.size > 0
      logger.debug "#{@person.errors.size.to_s} Validation errors found, returning to form"
      render action: "edit"
      return
    end

    @person = Person.find(params[:id])

    if @person.update_attributes(params[:person])
      #add portrait (if any)
      add_portrait(params)

      #finally save the person again
      logger.debug '@person.errors.size = ' + @person.errors.size.to_s
      @person.save!

      logger.debug 'Saved new person successfully'
      redirect_to @person, notice: 'Person was successfully updated.'
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
