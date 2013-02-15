# -*- encoding : utf-8 -*-
class PeopleController < ApplicationController
  load_and_authorize_resource
  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def show_image
    @person = Person.find(params[:id])
    image_content = @person.person_image_representation.last.person_image_files.last.content.content
    original_filename = @person.person_image_representation.last.person_image_files.last.original_filename
    mime_type = @person.person_image_representation.last.person_image_files.last.mime_type
    send_data(image_content, {:filename => original_filename, :type => mime_type, :disposition => 'inline'})
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def create
    @person = Person.new(params[:person])

    if @person.save!

      unless params[:person_image_file].blank?
        person_image_representation = PersonImageRepresentation.new
        person_image_representation.save!

        person_image_file = BasicFile.new
        person_image_file.add_file(params[:person_image_file])
        person_image_file.container = person_image_representation
        person_image_file.save!
        person_image_representation.person_image_files << person_image_file

        person_image_representation.person = @person
        person_image_representation.save!

        @person.person_image_representation << person_image_representation
      end

      redirect_to @person, notice: 'Person was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @person = Person.find(params[:id])

    if @person.update_attributes(params[:person])

      unless params[:person_image_file].blank?
        person_image_representation = PersonImageRepresentation.find(@person.person_image_representation.first.pid)
        person_image_representation.person_image_files.delete_at(0)
        person_image_representation.save!

        @person.person_image_representation.delete_at(0)
        @person.save!

        person_image_representation = PersonImageRepresentation.new
        person_image_representation.save!
        person_image_file = BasicFile.new
        person_image_file.add_file(params[:person_image_file])
        person_image_file.container = person_image_representation
        person_image_file.save!
        person_image_representation.person_image_files << person_image_file

        person_image_representation.person = @person
        person_image_representation.save!

      end
      @person.save!
      redirect_to @person, notice: 'Person was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    redirect_to people_url
  end
end
