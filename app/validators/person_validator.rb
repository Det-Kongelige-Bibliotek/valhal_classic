# -*- encoding : utf-8 -*-
#Validator class for the Person model contains any custom Rails validation
class PersonValidator < ActiveModel::Validator

  #Overridden from ActiveModel::Validator
  def validate(record)
    if(has_duplicate_person(record))
      record.errors[:person] << "cannot be duplicated"
    end
  end

  # Validates whether anoter person with same name, birth and death dates exists.
  def has_duplicate_person(record)
    logger.debug "Looking for duplicate people with name = #{record.comma_seperated_lastname_firstname}"
    if record.id.eql? "__DO_NOT_USE__"
      potential_people = ActiveFedora::SolrService.query("search_result_title_t:#{record.comma_seperated_lastname_firstname} AND has_model_s:\"info:fedora/afmodel:Person\"")
    else
      logger.debug "self.id = #{record.id}"
      logger.debug "self.pid = #{record.pid}"
      potential_people = ActiveFedora::SolrService.query("search_result_title_t:#{record.comma_seperated_lastname_firstname} AND has_model_s:\"info:fedora/afmodel:Person\" NOT id:\"#{record.id}\"")
    end
    logger.info "duplicate person names count = #{potential_people.size}"
    potential_people.each do |person|
      #logger.info "Comparing '" + record.to_s + "' with person '" + person.to_s
      if is_same_date(person["date_of_birth_t"], record.date_of_birth) && is_same_date(person["date_of_death_t"], record.date_of_death)
        logger.error "duplicate person found: " + person.to_s
        return true
      end
    end
    return false
  end

  # validates whether two dates are the same.
  # returns true if either both are undefined (nil or empty) or they are identical.
  def is_same_date(dateList, date)
    if is_undefined(dateList) && is_undefined(date)
      return true
    end
    if is_undefined(dateList) || is_undefined(date)
      return false
    end

    return dateList.first.eql? date
  end

  # Returns whether the date is either nil or empty.
  def is_undefined(date)
    return date.nil? || date.empty?
  end

end