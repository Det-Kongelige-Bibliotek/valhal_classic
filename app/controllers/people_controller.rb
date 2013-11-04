# -*- encoding : utf-8 -*-
class PeopleController < ApplicationController
  include PeopleHelper # methods: add_portrait, add_person_description
  include PreservationHelper # methods: update_preservation_profile_from_controller, update_preservation_metadata_from_controller

  load_and_authorize_resource

  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def show_image
    @person = Person.find(params[:id])
    image_url(@person.get_all_portraits.last)
  end

  def image_url(portrait = nil)
    if portrait.nil?
      portrait = Person.find(params[:id]).get_all_portraits.last
    end
    if portrait.nil?
      send_data({}, {:status => 404})
      return
    end

    image_file = portrait.representations.last.files.last
    image_content = image_file.content.content
    original_filename = image_file.original_filename
    mime_type = image_file.mime_type
    send_data(image_content, {:filename => original_filename, :type => mime_type, :disposition => 'inline'})
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def create
    if invalid_arguments?
      logger.debug "#{@person.errors.size.to_s}" + ' Validation errors found, returning to form'
      render action: 'new'
      return
    end

    #create a person object and save it so component parts can be linked to it
    @person = Person.new(params[:person])
    if @person.save
      handle_arguments
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if invalid_arguments?
      logger.debug "#{@person.errors.size.to_s}" + ' Validation errors found, returning to form'
      render action: 'edit'
      return
    end

    @person = Person.find(params[:id])

    if @person.update_attributes(params[:person])
      handle_arguments
      redirect_to @person, notice: 'Person was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    redirect_to people_url
  end

  # Updates the preservation profile metadata.
  def update_preservation_profile
    @person = Person.find(params[:id])
    begin
      update_preservation_profile_from_controller(params, update_preservation_metadata_person_url, nil, nil, @person)
    rescue => error
      @person.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Updates the preservation state metadata.
  def update_preservation_metadata
    @person = Person.find(params[:id])
    update_preservation_metadata_from_controller(params, @person)
  end

  private
  # handles the parameters
  # If any portrait is defined, then a work with the image will be added as portrait to the person
  # If any TEI basic_files is defined, then it is added as a person description of the person.
  def handle_arguments
    if (!params[:portrait].blank?) && (!params[:portrait][:portrait_file].blank?)
      logger.debug "Valid image basic_files uploaded, creating image related objects"
      add_portrait(params[:portrait][:portrait_file], params[:portrait_representation_metadata], params[:portrait_metadata], @person)
    end

    if (!params[:tei].blank?) && (!params[:tei][:tei_file].blank?)
      logger.debug "Valid image basic_files uploaded, creating image related objects"
      add_person_description(params[:tei_metadata], params[:tei][:tei_file], params[:tei_representation_metadata], params[:person_description_metadata], @person)
    end
  end

  # validates the parameter arguments.
  # ensures that the parameters are not empty, that the portrait is a image basic_files, and that the TEI basic_files are in XML.
  def invalid_arguments?
    if params.empty? || params[:person].nil?
      @person.errors.add(:metadata, 'The work cannot exist without metadata.')
    end
    if (!params[:portrait].blank? && !params[:portrait][:portrait_file].blank?)  && (!params[:portrait][:portrait_file].content_type.start_with? 'image/')
      logger.error 'Invalid basic_files type uploaded: ' + params[:portrait][:portrait_file].content_type.to_s
      @person.errors.add(:portrait_file, ' - You tried to upload a non-image basic_files, please select a valid image basic_files')
    end
    if (!params[:tei].blank? && !params[:tei][:tei_file].blank?) && (params[:tei][:tei_file].content_type !=  'text/xml')
      logger.error 'Invalid basic_files type uploaded: ' + params[:tei][:tei_file].content_type.to_s
      @person.errors.add(:tei_file, ' - You tried to upload a non-xml basic_files as a person description')
    end

    logger.debug 'Validation finished'
    @person.errors.size > 0
  end
end
