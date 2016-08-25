module ApplicationHelper
  def set_theme
    if session[:referrer].present?
      Settings.theme[URI(session[:referrer]).host] || "default"
    else
      "default"
    end
  end
end
