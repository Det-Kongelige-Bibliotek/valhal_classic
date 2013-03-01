# -*- encoding : utf-8 -*-
#Validator class for the Person model contains any custom Rails validation
class PersonValidator < ActiveModel::Validator

  #Overridden from ActiveModel::Validator
  def validate(record)
    logger.debug "Looking for duplicate people with name = #{record.comma_seperated_lastname_firstname}"
    if record.id.eql? "__DO_NOT_USE__"
      potential_people = ActiveFedora::SolrService.query("search_result_title_t:#{record.comma_seperated_lastname_firstname} AND has_model_s:\"info:fedora/afmodel:Person\"")
    else
      logger.debug "self.id = #{record.id}"
      logger.debug "self.pid = #{record.pid}"
      potential_people = ActiveFedora::SolrService.query("search_result_title_t:#{record.comma_seperated_lastname_firstname} AND has_model_s:\"info:fedora/afmodel:Person\" NOT id:\"#{record.id}\"")
    end
    logger.error "duplicate person names count = #{potential_people.size}"
    potential_people.each do |person|
      if is_same_date(person["date_of_birth_t"], record.date_of_birth) && is_same_date(person["date_of_death_t"], record.date_of_death)
        record.errors[:person] << "cannot be duplicated"
      end
    end
  end

  # validates whether two dates are the same.
  # returns true if either both are undefined (nil) or they are identical.
  def is_same_date(dateList, date)
    if dateList.nil? && date.nil?
      return true
    end
    if dateList.nil? || date.nil?
      return false
    end

    return dateList.first.eql? date
  end

end