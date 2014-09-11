# -*- encoding : utf-8 -*-
# Controller for dealing with AuthorityMetadataUnit objects from Fedora for create, read, update or display to the front-end
class AuthorityMetadataUnitsController < ApplicationController
  authorize_resource

  before_action :get_klazz

  def get_klazz
    case params[:type]
      when 'agent/person'
        @klazz = Person
      when 'place'
        @klazz = Place
      else
        @klazz = AuthorityMetadataUnit
    end
  end

  def index
    if params[:type].blank?
      @amus = nil
    else
      @amus = @klazz.all
    end
  end

  def show
    @amu = @klazz.find(params[:id])
  end

  def new
    @amu = @klazz.new()
    @amu.type = params[:type]
  end

  def edit
    @amu = @klazz.find(params[:id])
  end

  def create
    @amu = @klazz.new(params[:amu])
    @amu.type = params[:type]

    if @amu.save
      redirect_to @amu, notice: '@klazz was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    @amu = @klazz.find(params[:id])

    ref=[]
    params[:reference].each do |m, v|
      ref << v #unless v.blank?
    end
    @amu.reference=ref

    if @amu.update_attributes(params[:amu])
      redirect_to @amu, notice: '@klazz was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @amu = @klazz.find(params[:id])
    @amu.destroy

    redirect_to authority_metadata_units_path
  end
end
