Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.logger = Rails.logger
  provider :github, Settings.github.key, Settings.github.secret
  provider :weibo, ENV['WEIBO_KEY'], ENV['WEIBO_SECRET']
end
