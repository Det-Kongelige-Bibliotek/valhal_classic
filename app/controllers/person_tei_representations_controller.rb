# -*- encoding : utf-8 -*-
class PersonTeiRepresentationsController < ApplicationController
  include Hydra::Controller::UploadBehavior
  load_and_authorize_resource
  def index
    @person_tei_representations = PersonTeiRepresentation.all
  end

  def edit
    @person_tei_representation = PersonTeiRepresentation.find(params[:id])
  end

  def new
    @person_tei_representation = PersonTeiRepresentation.new
  end

  def show
    @person_tei_representation = PersonTeiRepresentation.find(params[:id])
  end

  def update
    @person_tei_representation = PersonTeiRepresentation.find(params[:id])
    @person_tei_representation.update_attributes(params[:person_tei_representation])
    @person_tei_representation.save
    redirect_to person_tei_representations_path, :notice => "TEI repræsentationen af personen er blevet ændret"
  end

  def create
    @person_tei_representation = PersonTeiRepresentation.new(params[:person_tei_representation])
    #TODO: the ':file_data' parameter is never set in the view.
    file = params[:file_data]
    unless file.nil?
      @person_tei_representation.teiFile.content = file.read
    end
    @person_tei_representation.save
    redirect_to person_tei_representations_path, notice: "TEI repræsentationen af personen er blevet tilføjet"
  end

  def destroy
    @person_tei_representation = PersonTeiRepresentation.find(params[:id])
    @person_tei_representation.destroy

    redirect_to person_tei_representations_url
  end
end
