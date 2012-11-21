# -*- encoding : utf-8 -*-
class AuthorsController < ApplicationController

  def index
    @authors = Author.all
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new
    unless params[:author][:upload].blank?
      content = File.open(params[:author][:upload], 'r:utf-8').read
      @author.descMetadata.content = content
    end

    unless params[:author][:forename].blank?
      @author.forename = params[:author][:forename]
    end

    unless params[:author][:surname].blank?
      @author.surname = params[:author][:surname]
    end

    unless params[:author][:date_of_birth].blank?
      @author.date_of_birth = params[:author][:date_of_birth]
    end

    unless params[:author][:date_of_death].blank?
      @author.date_of_death = params[:author][:date_of_death]
    end

    @author.save
    redirect_to authors_path

  end

end
