# -*- encoding : utf-8 -*-
# Controller for dealing with AuthorityMetadataUnit objects from Fedora for create, read, update or display to the front-end
class AuthorityMetadataUnitsController < ApplicationController

  def index
    @amus = AuthorityMetadataUnit.all
  end

  def show
    @amu = AuthorityMetadataUnit.find(params[:id])
  end

  def new
    @amu = AuthorityMetadataUnit.new
  end

  def edit
    @amu = AuthorityMetadataUnit.find(params[:id])
  end

  def create
    @amu = AuthorityMetadataUnit.new(params[:amu])

    if @amu.save
      redirect_to @amu, notice: 'AuthorityMetadataUnit was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    @amu = AuthorityMetadataUnit.find(params[:id])

    ref=[]
    params[:reference].each do |m, v|
      ref << v #unless v.blank?
    end
    @amu.reference=ref

    if @amu.update_attributes(params[:amu])
      redirect_to @amu, notice: 'AuthorityMetadataUnit was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @amu = AuthorityMetadataUnit.find(params[:id])
    @amu.destroy

    redirect_to authority_metadata_units_path
  end
end
