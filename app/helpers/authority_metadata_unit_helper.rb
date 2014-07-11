# -*- encoding : utf-8 -*-

# The helper methods for the people.
# Provides methods for generating related manifestations and relationships for people.
module AuthorityMetadataUnitHelper
  include WorkHelper

  # Creates and adds a portrait for the agent/person.
  # @param file The image file for the portrait
  # @param representation_metadata The metadata for the representation containing the image file.
  # @param portrait_metadata The metadata for the representation. If no work_type is defined, then it is set to 'PersonPortrait'
  # If no title is defined, then it will be defined as the portrait of the agent/person.
  # @return false if operation was unsuccessful
  # @param agent/person The agent/person to have the portrait added.
  def add_portrait(file, representation_metadata, portrait_metadata, agent_person)
    if portrait_metadata[:workType].blank?
      portrait_metadata[:workType] = 'PersonPortrait'
    end
    if portrait_metadata[:title].blank?
      portrait_metadata[:title] = 'Portrait of ' + agent_person.name
    end

    portrait = Work.create(portrait_metadata)
    unless add_single_file_rep(file, representation_metadata, nil, portrait)
      return false
    end

    set_concerned_agents([agent_person.pid], portrait)
  end

  # Creates and adds a agent/person description for the agent/person.
  # @param tei_metadata The metadata for the tei file.
  # @param file The tei file for the portrait.
  # @param representation_metadata The metadata for the representation containing the tei file.
  # @param agent_person_description_metadata The metadata hash for the portrait. If no work_type is given, then it is set to 'PersonDescription'.
  # If no title has been defined, then it will be set to description of the agent/person.
  # @param agent_person The agent/person to have the portrait added.
  # @return false if operation was unsuccessful
  def add_person_description(tei_metadata, file, representation_metadata, agent_person_description_metadata, agent_person)
    if agent_person_description_metadata[:workType].blank?
      agent_person_description_metadata[:workType] = 'PersonDescription'
    end
    if agent_person_description_metadata[:title].blank?
      agent_person_description_metadata[:title] = 'Person description of ' + agent_person.name
    end

    portrait = Work.create(agent_person_description_metadata)
    unless add_single_tei_rep(tei_metadata, file, representation_metadata, portrait)
      return false
    end

    set_concerned_agents([agent_person.pid], portrait)
  end
end
