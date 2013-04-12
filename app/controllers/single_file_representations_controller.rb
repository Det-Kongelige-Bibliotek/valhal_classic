class SingleFileRepresentationsController < ApplicationController
  def index
    @single_file_representations = SingleFileRepresentation.all

  end

  def show
    @single_file_representation = SingleFileRepresentation.find(params[:id])

  end

  def new
    @single_file_representation = SingleFileRepresentation.new

  end

  def edit
    @single_file_representation = SingleFileRepresentation.find(params[:id])
  end

  def create
    @single_file_representation = SingleFileRepresentation.new(params[:single_file_representation])

    if @single_file_representation.save
      redirect_to @single_file_representation, notice: 'Single file representation was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @single_file_representation = SingleFileRepresentation.find(params[:id])

    if @single_file_representation.update_attributes(params[:single_file_representation])
      redirect_to @single_file_representation, notice: 'Single file representation was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @single_file_representation = SingleFileRepresentation.find(params[:id])
    @single_file_representation.destroy

    redirect_to single_file_representations_url
  end
end
