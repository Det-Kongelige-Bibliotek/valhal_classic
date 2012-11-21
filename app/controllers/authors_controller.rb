# -*- encoding : utf-8 -*-
class AuthorsController < ApplicationController
  def index
    @author = Author.all
  end

  def new
    @author = Author.new
  end

  def review
    @author = Author.new(params[:author])
    if params[:author][:surname].blank?
      @author.errors[:surname] = "write Author's surname"
      render :action=>'new'
      return
    end
    redirect_to author_view_path
  end

  def create
    @author = Author.new(params[:author])
    if params[:author][:surname].blank?
      @author.errors[:surname] = "write Author's surname"
      render :action=>'new'
      return
    end

    @author.save
    redirect_to  author_index_path, :notice=>"Author is saved"
  end

  def publish
    @author = Author.new(params[:author])
    if params[:author][:surname].blank?
      @author.errors[:surname] = "write Author's surname"
      render :action=>'new'
      return
    end
    @author.save
    redirect_to author_view_path, :notice=>"Author is saved and published"
  end

  def add_image
    @author = Author.new(params[:author])
    if params[:author][:surname].blank?
      @author.errors[:surname] = "write Author's surname"
      render :action=>'new'
      return
    end
    author.image_link =  params[:author][image_link]
    @author.save
  end

  def browse

  end
end
