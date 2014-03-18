module ViewHelper
  def is_front_page?
    (params[:controller] == 'catalog' && params[:action] == 'index' && !has_search_parameters?)
  end
end