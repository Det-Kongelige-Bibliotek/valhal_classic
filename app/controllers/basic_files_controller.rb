# -*- encoding : utf-8 -*-
#Controller for retrieving BasicFile objects from Fedora for display to the front-end
class BasicFilesController < ApplicationController
  include AdministrationHelper # methods: update_administrative_metadata_from_controller
  include PreservationHelper # methods: update_preservation_profile_from_controller

  

  # Retrieves the basic file for the show view
  def show
    authorize! :read, params[:id]
    @file = BasicFile.find(params[:id])
  end

  def characterize_file
    authorize! :edit, params[:id]
    @file = BasicFile.find(params[:id])
    begin
      tmpfile = Tempfile.new(@file.original_filename)
      begin
        tmpfile << @file.content.content.force_encoding("UTF-8")
        tmpfile.flush
        tmpfile.close

        f = File.open(tmpfile.path)
        @file.add_fits_metadata_datastream(f)
        f.close
      ensure
        tmpfile.unlink   # deletes the temp file
      end

    redirect_to @file, notice: 'File characterization performed.'
    rescue => error
      error_msg = "Could not perform characterization: #{error.inspect}"
      error.backtrace.each do |l|
        error_msg += "\n#{l}"
      end
      logger.error error_msg
      @file.errors[:characterization] << error.inspect.to_s
      render action: 'show'
    end
  end

  # Updates the preservation profile metadata.
  def update_preservation_profile
    authorize! :edit, params[:id]
    @file = BasicFile.find(params[:id])
    begin
      notice = update_preservation_profile_from_controller(params, @file)
      redirect_to @file, notice: notice
    rescue => error
      error_msg = "Could not update preservation profile: #{error.inspect}"
      error.backtrace.each do |l|
        error_msg += "\n#{l}"
      end
      logger.error error_msg
      @file.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Retrieves the basic file for the preservation view
  def preservation
    authorize! :read, params[:id]
    @file = BasicFile.find(params[:id])
  end

  # Retrieves the basic file for the administration view
  def administration
    authorize! :read, params[:id]
    @file = BasicFile.find(params[:id])
  end

  # Updates the administration metadata for the basic file.
  def update_administration
    authorize! :edit, params[:id]
    @file = BasicFile.find(params[:id])
    begin
      update_administrative_metadata_from_controller(params, @file)
      redirect_to @file, notice: 'Updated the administrative metadata'
    rescue => error
      error_msg = "Could not update administrative metadata: #{error.inspect}"
      error.backtrace.each do |l|
        error_msg += "\n#{l}"
      end
      logger.error error_msg
      @file.errors[:administrative_metadata] << error.inspect.to_s
      render action: 'administration'
    end
  end

  # Retrieve the content file for a given BasicFile.
  # If a wrong BasicFile-id, then a 404 is returned.
  # If something goes wrong service-side, then a 500 is returned.
  def download
    authorize! :read, params[:id]
    begin
      @file = BasicFile.find(params[:id])
      send_data @file.content.content, {:filename => @file.original_filename, :type => @file.mime_type}
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The basic_files you requested could not be found in Fedora! Please contact your system administrator'
      logger.error obj_not_found.to_s
      render text: obj_not_found.to_s, status: 404
    rescue => standard_error
      flash[:error] = 'An error has occurred. Please contact your system administrator'
      logger.error standard_error.to_s
      render text: standard_error.to_s, status: 500
    end
  end
  
  def edit_permission
    authorize! :edit, params[:id]
    @file = BasicFile.find(params[:id])
  end

  def update_permission
    authorize! :edit, params[:id]
    @file = BasicFile.find(params[:id])
    @file.discover_groups_string = params['@file'][:discover_access]
    @file.read_groups_string = params['@file'][:read_access]
    @file.edit_groups_string = params['@file'][:edit_access]
    @file.save
    render action: 'edit'
  end
  
end
