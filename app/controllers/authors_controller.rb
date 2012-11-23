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
    unless check_params?(@author, params[:author])
      render action:"edit"
      return
    end
    @author.update_attributes(params[:author])
    @author.save
    redirect_to authors_path, :notice => "Forfatter er blevet ændret"
  end

  def create
    @author = Author.new(params[:author])

    unless check_params?(@author, params[:author])
      render action:"new"
      return
    end

    @author.save
    redirect_to authors_path, notice: "forfatter er blevet tilføjet"
  end


  private
  def params_not_valid(params)
    params.each do |key, value|
      if value.blank?
        yield key
      end
    end
  end

  #checks the params to see that they are valid
  #will return true if all params are valid and else false
  private
  def check_params?(author, values)
    valid = true
    params_not_valid(values) do |name|
      author.errors[name] = "must not be blank"
      valid = false
    end
    valid

  end



end
