class Submail
  include HTTParty
  base_uri 'https://api.submail.cn'

  def sms(to,code)
		config = Settings.submail.sms_config.to_hash
		content={to:to, vars:{code:code}}
		options={body: config.merge(content)}
    self.class.post("/message/xsend.json", options)
  end

end
