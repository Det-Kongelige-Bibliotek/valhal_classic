module ViewHelper
  def is_front_page?
    (params[:controller] == 'catalog' && params[:action] == 'index' && !has_search_parameters?)
  end

  # Used to determine truthiness of different object types
  # i.e. should we show this value or not?
  def displayable?(obj)
    if obj.class == Array
      obj.length > 0
    else
      obj
    end
  end


  def helper_method
    "helper method!!!!"
  end
end