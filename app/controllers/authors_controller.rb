class AuthorsController < ApplicationController

  def index

  end

  def new
    @author = Author.new
  end

end
