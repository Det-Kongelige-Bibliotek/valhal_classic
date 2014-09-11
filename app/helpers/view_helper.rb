module ViewHelper
  def is_front_page?
    (params[:controller] == 'catalog' && params[:action] == 'index' && !has_search_parameters?)
  end

  # check if string contains
  # true, t, yes, y, or 1
  # @param String s
  # @return Boolean
  def true_string?(s)
    !!(/^(true|t|yes|y|1)$/i).match(s)
  end
end