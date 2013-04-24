# -*- encoding : utf-8 -*-
class WorksController < ApplicationController
  include ManifestationsHelper

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

  def validate_work(params)
    #Validate form params
    logger.debug 'Validating parameters...'
    if params.empty?
      @work.errors.add(:metadata, "The work cannot exist without metadata.")
    end

    logger.debug 'Validation finished'
  end

  def create
    #Validation passed begin processing parameters
    @work = Work.new(params[:work])

    validate_work(params)
    if @work.errors.size > 0
      logger.debug "#{@work.errors.size.to_s} Validation errors found, returning to form"
      render action: "new"
      return
    end

    if @work.save
      # add the authors to the work
      if !params[:person].blank? && !params[:person][:id].blank?
        add_authors(params[:person][:id], @work)
      end

      #Create representation of work using uploaded file if a file was uploaded
      if !params[:file].blank? && !params[:file][:file].blank?
        logger.debug "Creating a tei representation"
        add_single_file_representation(params[:file][:file], params[:tei], @work)
      end

      redirect_to @work, notice: 'Work was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @work = Work.find(params[:id])

    validate_work(params)
    if @work.errors.size > 0
      logger.debug "#{@work.errors.size.to_s} Validation errors found, returning to form"
      render action: "edit"
      return
    end

    if @work.update_attributes(params[:work])
      if !params[:file].blank? && !params[:file][:file].blank?
          logger.debug "Creating a representation"
          add_single_file_representation(params[:file][:file], params[:tei], @work)
      end
      # add the authors to the work
      if !params[:person].blank? && !params[:person][:id].blank?
        # Remove any existing relationships
        @work.authors.clear
        # add new persons as authors
        add_authors(params[:person][:id], @work)
      end
      redirect_to @work, notice: 'Work was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @work = Work.find(params[:id])
    @work.destroy

    redirect_to works_url
  end
end
