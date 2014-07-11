# -*- encoding : utf-8 -*-
class WorksController < ApplicationController
  include WorkHelper # methods: add_single_file_rep, set_authors, set_concerned_people
  include PreservationHelper # methods: update_preservation_profile_from_controller
  include DisseminationService # methods: ??

  authorize_resource

  def index
    @works = Work.all
  end

  def show
    @work = Work.find(params[:id])
  end

  def show_agent
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

  def create
    #Validation passed begin processing parameters
    @work = Work.new(params[:work])

    if invalid_arguments?(params)
      logger.debug "#{@work.errors.size.to_s} Validation errors found, returning to form"
      render action: 'new'
      return
    end

    if @work.save
      redirect_to show_agent_work_path @work
    else
      render action: 'new'
    end
  end

  def update_agent
    @work = Work.find(params[:id])
    handle_arguments
    if @work.save
      redirect_to show_metadata_work_path @work
    else
      render action "update_agent"
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

    if !params[:multiple_files].blank? && !params[:multiple_files][:basic_files].blank?
      logger.debug 'Allowing user to order files...'
      render action: 'sort_multiple_files'
    else
      redirect_to @work, notice: 'Work was successfully created.'
    end
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

  def finish_work_with_structmap
    @work = Work.find(params[:id])
    create_structmap_for_representation(params[:structmap_file_order], @work.ordered_instances.last)
    redirect_to @work, notice: 'Work was successfully created.'
  end

  private
  # Handles the parameter arguments
  # If single basic_files is given, then a SingeFileRepresentation is made from it.
  # If multiple basic_files is given, then a OrderedInstance is made from it.
  #
  def handle_arguments
    if !params[:single_file].blank? && !params[:single_file][:basic_files].blank?
      logger.debug 'Creating a representation'
      add_single_file_rep(params[:single_file][:basic_files], params[:rep], params[:skip_file_characterisation], @work)
    end

    # add the agents to the work
    if !params[:agent].blank? && !params[:agent][:id].blank?
      set_agents(params[:agent][:id], @work)
    end

    #Create ordered representation
    if !params[:multiple_files].blank? && !params[:multiple_files][:basic_files].blank?
      logger.debug 'Creating an ordered representation'
      add_ordered_file_rep(params[:multiple_files][:basic_files], params[:rep], params[:skip_file_characterisation], @work)
    end

    # add the described persons to the work
    if !params[:agent_concerned].blank? && !params[:agent_concerned][:id].blank?
      set_concerned_agents(params[:agent_concerned][:id], @work)
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
