# -*- encoding : utf-8 -*-

# The helper methods for the administration of elements.
# Provides methods for managing the administrative metadata, etc.
module AdministrationHelper
  # Updates the administrative metadata from the controller.
  # @param params The parameters from the controller.
  # @param element The element to have its administrative metadata updated.
  def update_administrative_metadata_from_controller(params, element)
    logger.info "Update administrative metadata for #{element.class} - #{element.id}"
    element.update_attributes(params[:administration])
    cascading_administrative_metadata(params, element)
  end

  private
  # Check whether the metadata update should be cascading, and also perform the cascading effect.
  # @param params The parameter from the controller. Contains the parameter for whether the adminstrative metadata
  # should be cascading.
  # @param element The element to have stuff cascading.
  def cascading_administrative_metadata(params, element)
    if element.can_perform_cascading? && params['cascading']['cascading'] == Constants::CASCADING_EFFECT_TRUE
      element.cascading_elements.each do |ce|
        update_administrative_metadata_from_controller(params, ce)
      end
    end
  end
end
