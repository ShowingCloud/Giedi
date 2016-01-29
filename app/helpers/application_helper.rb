module ApplicationHelper

  # def render_page_title
  #   site_name = Settings.app_name
  #   title = @page_title ? "#{@page_title} - #{site_name}" : site_name
  #   content_tag('title', title, nil, false)
  # end
  #
  # def memory_cache(*keys)
  #   return yield unless Rails.application.config.cache_classes
  #
  #   $memory_store.fetch(keys) { yield }
  # end
  #
  # def cached_asset_path(name)
  #   memory_cache('asset_path', name) do
  #     asset_path(name)
  #   end
  # end

end
