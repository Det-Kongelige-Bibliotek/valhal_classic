# -*- encoding : utf-8 -*-
class WorksController < ApplicationController

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
        add_authors(params[:person][:id])
      end

      #Create representation of work using uploaded file if a file was uploaded
      if !params[:file].blank? && !params[:file][:file].blank?
        logger.debug "Creating a tei representation"
        add_representation
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
          add_tei_representation
      end
      # add the authors to the work
      if !params[:person].blank? && !params[:person][:id].blank?
        # Remove any existing relationships
        @work.authors.clear
        # add new persons as authors
        add_authors(params[:person][:id])
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

  # creates the tei representation with the tei file
  private
  def add_representation
    rep = SingleFileRepresentation.new(params[:rep])
    rep.save!

    rep_file = BasicFile.new
    rep_file.add_file(params[:file][:file])
    rep.files << rep_file
    @work.representations << rep

    @work.save
  end

  # adds the person defined in the params as authors
  private
  def add_authors(ids)
    # add the authors to the work
    ids.each do |author_pid|
      if author_pid && !author_pid.empty?
        author = Person.find(author_pid)
        @work.authors << author

        # TODO: Relationship should not be defined both ways.
        author.authored_works << @work
        author.save!
      end
    end
    @work.save!
  end
end
