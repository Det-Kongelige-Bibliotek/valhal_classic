# -*- encoding : utf-8 -*-
class WorksController < ApplicationController
  include ManifestationsHelper # methods: add_single_file_rep, set_authors, set_concerned_people
  include PreservationHelper # methods: update_preservation_profile_from_controller, update_preservation_metadata_from_controller

  authorize_resource

  def index
    @works = Work.all
  end

  def show
    @work = Work.find(params[:id])
  end

  def show_person
    @work = Work.find(params[:id])
  end

  def show_metadata
    @work = Work.find(params[:id])
  end

  def show_file
    @work = Work.find(params[:id])
  end

  def new
    @work = Work.new
  end

  def edit
    @work = Work.find(params[:id])
  end

  def preservation
    @work = Work.find(params[:id])
  end

  def create
    #Validation passed begin processing parameters
    @work = Work.new(params[:work])

    if invalid_arguments?(params)
      logger.debug "#{@work.errors.size.to_s} Validation errors found, returning to form"
      render action: 'new'
      return
    end

    if @work.save
      redirect_to  show_person_work_path @work
    else
      render action: 'new'
    end
  end

  def update_person
    @work = Work.find(params[:id])
    handle_arguments
    if @work.save
      redirect_to show_metadata_work_path @work
    else
      render action "update_person"
    end
  end

  def update_metadata
    @work = Work.find(params[:id])
    if @work.update_attributes(params[:work])
      redirect_to show_file_work_path @work
    else
      render action: "show_metadata"
    end
  end

  def update_file
    @work = Work.find(params[:id])
    handle_arguments
    redirect_to @work, notice: 'Work was successfully created.'
  end

  def save_edit
    @work = Work.find(params[:id])
    if @work.update_attributes(params[:work])
      handle_arguments
      redirect_to show_file_work_path @work
    else
      render action: "edit"
    end
  end

  def file_edit
    @work = Work.find(params[:id])
    if @work.update_attributes(params[:work])
      handle_arguments
    else
      render action: "edit"
    end
  end

  def destroy
    @work = Work.find(params[:id])
    @work.destroy

    redirect_to works_url
  end

  # Updates the preservation profile metadata.
  def update_preservation_profile
    @work = Work.find(params[:id])
    begin
      notice = update_preservation_profile_from_controller(params, @work)
      redirect_to @work, notice: notice
    rescue => error
      logger.warn "Could not update preservation profile: #{error.inspect}\n#{error.backtrace}"
      @work.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Updates the preservation state metadata.
  def update_preservation_metadata
    begin
      @work = Work.find(params[:id])
      status = update_preservation_metadata_from_controller(params, @work)
      render text: status, status: status
    rescue ValhalErrors::InvalidStateError => error
      logger.warn "Sending a 403 response to the error: #{error.inspect}"
      render text: error, status: :forbidden #403
    rescue ActiveFedora::ObjectNotFoundError => error
      logger.warn "Sending a 404 response to the error: #{error.inspect}"
      render text: error, status: :not_found #404
    rescue => error
      logger.warn "Could not update preservation metadata: #{error.inspect}"
      render text: error, status: :internal_server_error #500
    end
  end

  private
  # Handles the parameter arguments
  # If any single basic_files is given, then a SingeFileRepresentation is made from it.
  #
  def handle_arguments
    if !params[:single_file].blank? && !params[:single_file][:basic_files].blank?
      logger.debug 'Creating a representation'
      add_single_file_rep(params[:single_file][:basic_files], params[:rep], params[:skip_file_characterisation], @work)
    end
    # add the authors to the work
    if !params[:person].blank? && !params[:person][:id].blank?
      set_authors(params[:person][:id], @work)
    end

    # add the described persons to the work
    if !params[:person_concerned].blank? && !params[:person_concerned][:id].blank?
      set_concerned_people(params[:person_concerned][:id], @work)
    end
  end

  def invalid_arguments?(params)
    #Validate form params
    logger.debug 'Validating parameters...'
    if params.empty? || params[:work].empty?
      @work.errors.add(:metadata, 'The work cannot exist without metadata.')
    end

    logger.debug 'Validation finished'
    @work.errors.size > 0
  end
end
