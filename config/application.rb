require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DomeAbout
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths.push(*%W(#{config.root}/lib))

    config.time_zone = 'Asia/Shanghai'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = 'zh-CN'
    config.encoding = 'utf-8'
    config.cache_store = :redis_store, "redis://localhost:6379/0/cache"
  end
end
