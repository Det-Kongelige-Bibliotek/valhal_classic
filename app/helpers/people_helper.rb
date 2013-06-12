# -*- encoding : utf-8 -*-

# The helper methods for the people.
# Provides methods for generating related manifestations and relationships for people.
module PeopleHelper
  include ManifestationsHelper

  # Creates and adds a portrait for the person.
  # @param file The image file for the portrait
  # @param representation_metadata The metadata for the representation containing the image file.
  # @param portrait_metadata The metadata for the representation. If no work_type is defined, then it is set to 'PersonPortrait'
  # If no title is defined, then it will be defined as the portrait of the person.
  # @return false if operation was unsuccessful
  # @param person The person to have the portrait added.
  def add_portrait(file, representation_metadata, portrait_metadata, person)
    if portrait_metadata[:work_type].blank?
      portrait_metadata[:work_type] = 'PersonPortrait'
    end
    if portrait_metadata[:title].blank?
      portrait_metadata[:title] = 'Portrait of ' + @person.name
    end

    portrait = Work.create(portrait_metadata)
    unless add_single_file_rep(file, representation_metadata, portrait)
      return false
    end

    add_concerned_people([person.pid], portrait)
  end

  # Creates and adds a person description for the person.
  # @param tei_metadata The metadata for the tei file.
  # @param file The tei file for the portrait.
  # @param representation_metadata The metadata for the representation containing the tei file.
  # @param person_description_metadata The metadata hash for the portrait. If no work_type is given, then it is set to 'PersonDescription'.
  # If no title has been defined, then it will be set to description of the person.
  # @param person The person to have the portrait added.
  # @return false if operation was unsuccessful
  def add_person_description(tei_metadata, file, representation_metadata, person_description_metadata, person)
    if person_description_metadata[:work_type].blank?
      person_description_metadata[:work_type] = 'PersonDescription'
    end
    if person_description_metadata[:title].blank?
      person_description_metadata[:title] = 'Person description of ' + @person.name
    end

    portrait = Work.create(person_description_metadata)
    unless add_single_tei_rep(tei_metadata, file, representation_metadata, portrait)
      return false
    end

    add_concerned_people([person.pid], portrait)
  end
end