# -*- encoding : utf-8 -*-
class AuthorsController < ApplicationController

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
    @author.save
    redirect_to authors_path, notice: "forfatter er blevet tilføjet"
  end

end
