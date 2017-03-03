module ApplicationHelper
  def set_theme
    if session[:referrer].present?
      Settings.theme[URI(session[:referrer]).host] || 'default'
    else
      'default'
    end
  end

  def bind_link(provider)
    if @providers[provider]
      link_to '解绑', '/profile/unbind/' + @providers[provider].to_s
    else
      link_to '绑定', '/auth/' + provider
    end 
  end
end
