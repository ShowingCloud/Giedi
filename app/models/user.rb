class User < ActiveRecord::Base

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 20 }, uniqueness:true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    :unless => :phone?
  validates :phone, phone: { types: :mobile }, uniqueness:true, :unless => :email?
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
