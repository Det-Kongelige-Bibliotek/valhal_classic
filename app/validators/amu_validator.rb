# -*- encoding : utf-8 -*-
# Validator class for the AuthorityMetadataUnit model contains any custom Rails validation
class AMUValidator < ActiveModel::Validator

  #Overridden from ActiveModel::Validator
  # Validates that the authority metadata unit type is among the ones in the configuration.
  def validate(record)
    record.errors[:type] << "The type must be among #{AMU_TYPES}, but was: #{record.type}" unless AMU_TYPES.include? record.type
  end
end