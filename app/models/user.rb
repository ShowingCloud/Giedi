class User < ActiveRecord::Base
  attr_accessor :confirmation_token
  before_create :create_confirmation_digest, :if => :email
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



    def authenticated?(confirmation_token)
      return false if confirmation_digest.nil?
      BCrypt::Password.new(confirmation_digest).is_password?(confirmation_token)
    end

    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
      SecureRandom.urlsafe_base64
    end
private
    def create_confirmation_digest
      self.confirmation_token  = User.new_token
      self.confirmation_digest = User.digest(confirmation_token)
    end
end
