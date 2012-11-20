# -*- encoding : utf-8 -*-
class AuthorsController < ApplicationController

  def index

  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new
    unless params[:author][:upload].blank?
      content = File.open(params[:author][:upload], 'r:utf-8').read
      puts content.encoding.name
      @author.descMetadata.content = content
    end

    unless params[:author][:forename].blank?
      @author.forename = params[:author][:forename]
    end

    unless params[:author][:surname].blank?
      @author.surname = params[:author][:surname]
    end

    @author.save
    redirect_to author_index_path

  end

end
