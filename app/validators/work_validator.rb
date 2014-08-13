# -*- encoding : utf-8 -*-
#Validator class for the Work model contains any custom Rails validation
class WorkValidator < ActiveModel::Validator
  include ValidationHelper
  #Overridden from ActiveModel::Validator
  def validate(record)
    if duplicate_work?(record) || identifier_in_use?(record)
      record.errors[:work] << @error_message
    end
  end

  private
  def duplicate_work?(record)
    # this validation should be ignored until further notice
    return false
    solr_names = record.class.solr_names
    logger.debug ':workType = ' + record.workType.to_s + ', :title = ' + record.title.to_s + ', :subTitle = ' + record.subTitle.to_s + ', :pid = ' + record.pid.to_s
    if record.id.eql? "__DO_NOT_USE__"
      potential_works = Work.find_with_conditions("#{solr_names[:search_result_title]}:\"#{escape_bad_chars(record.get_title_for_display)}\"")
    else
      logger.debug "self.id = #{record.id}"
      logger.debug "self.pid = #{record.pid}"
      potential_works = Work.find_with_conditions("#{solr_names[:search_result_title]}:\"#{escape_bad_chars(record.get_title_for_display)}\" NOT id:\"#{record.id}\"")
    end
    logger.info "duplicate person names count = #{potential_works.length}"

    potential_works.each do |work|
      #logger.info "Comparing '" + record.to_s + "' with person '" + person.to_s
      if (work["search_result_work_type_tsi"] == record.workType)
        logger.error 'duplicate work found: ' + work.to_s
        @error_message = 'Cannot be duplicated. Another work with same work-type, title and subTitle exists.'
        return true
      end
    end
    return false
  end

  # Ensure the same identifier is not already in use
  # e.g. there should not be more than one work
  # with the same Aleph sysnum
  def identifier_in_use?(record)
    if record.identifier
      record.identifier.each do |id|
        if id['displayLabel']
          existing = Work.find(id['displayLabel'] + '_si' => id['value'])
          existing.each do |ex|
            if ex.pid != record.pid
              @error_message = "A record with #{id['displayLabel']} #{id['value']} already exists!"
              return true
            end
          end
        end
      end
    end
    false
  end

end