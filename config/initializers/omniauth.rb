Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.logger = Rails.logger
  provider :github, Settings.github.key, Settings.github.secret
  provider :weibo, Settings.weibo.key, Settings.weibo.secret,token_params: {redirect_uri: "http://account.domelab.com/auth/weibo/callback" }, :image_size => 'original'
  provider :qq_connect, Settings.qq.key, Settings.qq.secret
  provider :wechat, Settings.wechat.key, Settings.wechat.secret,:authorize_params => {:redirect_uri => "http://account.domelab.com/auth/wechat/callback"}
end
