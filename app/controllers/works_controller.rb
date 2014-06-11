# -*- encoding : utf-8 -*-
class WorksController < ApplicationController
  include ManifestationsHelper # methods: add_single_file_rep, set_authors, set_concerned_people
  include PreservationHelper # methods: update_preservation_profile_from_controller
  include DisseminationService # methods: ??
  include WorkflowService # methods: continue_workflow

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

  def dissemination
    @work = Work.find(params[:id])
  end

  def workflow
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
      error_msg = "Could not update preservation profile: #{error.inspect}"
      error.backtrace.each do |l|
        error_msg += "\n#{l}"
      end
      logger.error error_msg
      @work.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Updates the dissemination and performs the
  def send_to_dissemination
    @work = Work.find(params[:id])

    begin
      # Using Nokogiri to locate DOOMSDAY DEVICE!!!
      url = Nokogiri::XML(@work.descMetadata.to_xml).css("url").last.content()
      disseminate(@work, {'fileUri' => url}, DisseminationService::DISSEMINATION_TYPE_BIFROST_BOOKS)
      redirect_to @work, notice: "Sent to BifrostBooks"
    rescue NoMethodError => e
      @work.errors[:Metadata] << ": The metadata does not contain an URL for the pdf."
      render action: 'dissemination'
    rescue => e
      @work.errors[:dissemination] << "Error while trying to disseminate #{e.inspect}"
      render action: 'dissemination'
    end
  end

  # Updates the dissemination and performs the
  def perform_workflow
    @work = Work.find(params[:id])

    begin
      puts "DOOM IS ALL AROUND US"
      logger.info "Trying to continue the workflow for #{@work.inspect}: \n#{@work.workflowDatastream.content}"
      continue_workflow(@work)
      redirect_to workflow_work_path @work
    rescue => e
      logger.error "Issue performing the workflow: #{e.inspect}"
      logger.error e.backtrace.join("\n")
      @work.errors[:workflow] << "Error while trying to managing the workflow #{e.inspect}"
      render action: 'workflow'
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
