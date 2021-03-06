# -*- encoding : utf-8 -*-
# The helper methods for the administration of elements.
# Provides methods for managing the administrative metadata, etc.
module AdministrationHelper

  METADATA_RELATIONS_CONFIG = YAML.load_file("#{Rails.root}/config/admin_metadata_materials.yml")[Rails.env]
  # Updates the administrative metadata from the controller.
  # @param params The parameters from the controller.
  # @param element The element to have its administrative metadata updated.
  def update_administrative_metadata_from_controller(params, element, skip_cascading)
    logger.info "Update administrative metadata for #{element.class} - #{element.id}"
    element.update_attributes(params[:administration])
    unless skip_cascading
      cascading_administrative_metadata(params, element)
    end
  end

  def get_material_type_groups
    METADATA_RELATIONS_CONFIG['material_groups']
  end

  #Get list of material types belonging to the named group
  def get_material_types
    METADATA_RELATIONS_CONFIG['material_types']
  end

  private
  # Check whether the metadata update should be cascading, and also perform the cascading effect.
  # @param params The parameter from the controller. Contains the parameter for whether the adminstrative metadata
  # should be cascading.
  # @param element The element to have stuff cascading.
  def cascading_administrative_metadata(params, element)
    if element.can_perform_cascading? && params['cascading']['cascading'] == Constants::CASCADING_EFFECT_TRUE
      element.cascading_elements.each do |ce|
        update_administrative_metadata_from_controller(params, ce, true)
      end
    end
  end
end
