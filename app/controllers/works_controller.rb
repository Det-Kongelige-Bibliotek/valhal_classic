# -*- encoding : utf-8 -*-
class WorksController < ApplicationController
  include ManifestationsHelper
  load_and_authorize_resource

  def index
    @works = Work.all
  end

  def show
    @work = Work.find(params[:id])
  end

  def new
    @work = Work.new
  end

  def edit
    @work = Work.find(params[:id])
  end

  def person
    @work = Work.person
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
      render action: "part_edit"
    end
  end

  #def update
  #  @work = Work.find(params[:id])
  #
  #  if invalid_arguments?(params)
  #    logger.debug "#{@work.errors.size.to_s} Validation errors found, returning to form"
  #    render action: 'edit'
  #    return
  #  end
  #
  #  if @work.update_attributes(params[:work])
  #    handle_arguments
  #    redirect_to @work, notice: 'Work was successfully updated.'
  #  else
  #    render action: 'edit'
  #  end
  #end

  def destroy
    @work = Work.find(params[:id])
    @work.destroy

    redirect_to works_url
  end

  private

  # Handles the parameter arguments
  # If any single file is given, then a SingeFileRepresentation is made from it.
  #
  def handle_arguments
    if !params[:single_file].blank? && !params[:single_file][:file].blank?
      logger.debug 'Creating a representation'
      add_single_file_rep(params[:single_file][:file], params[:rep], @work)
    end
    # add the authors to the work
    if !params[:person].blank? && !params[:person][:id].blank?
      # Remove any existing relationships
      @work.authors.clear
      # add new persons as authors
      add_authors(params[:person][:id], @work)
    end

    # add the described persons to the work
    if !params[:person_concerned].blank? && !params[:person_concerned][:id].blank?
      # Remove any existing relationships
      @work.clear_concerned_people

      add_concerned_people(params[:person_concerned][:id], @work)
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
