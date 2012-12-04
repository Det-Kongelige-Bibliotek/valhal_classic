# -*- encoding : utf-8 -*-
class AuthorsController < ApplicationController
  include Hydra::Controller::UploadBehavior

  def index
    @authors = Author.all
  end

  def edit
    @author = Author.find(params[:id])
  end

  def new
    @author = Author.new
  end

  def show
    @author = Author.find(params[:id])
  end

  def update
    @author = Author.find(params[:id])
    @author.update_attributes(params[:author])
    @author.save
    redirect_to authors_path, :notice => "Forfatter er blevet ændret"
  end

  def create
    @author = Author.new(params[:author])
    file = params[:file_data]
        unless file === nil
          @author.teiFile.content = file.read
        end
    @author.save
    redirect_to authors_path, notice: "forfatter er blevet tilføjet"
  end

end
