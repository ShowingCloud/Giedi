class User < ActiveRecord::Base
  has_one :user_extra
    attr_accessor :confirmation_token, :pin, :activation_token, :reset_token
    before_create :create_confirmation_digest, if: :email
    before_save   :downcase_email
    validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 100 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false },
                      unless: :phone?
    validates :phone, phone: { types: :mobile }, uniqueness: true, unless: :email?
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    def authenticated?(confirmation_token)
        return false if confirmation_digest.nil?
        BCrypt::Password.new(confirmation_digest).is_password?(confirmation_token)
    end

    def authenticated_reset?(token)
        return false if reset_digest.nil?
        BCrypt::Password.new(reset_digest).is_password?(token)
    end

    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def self.new_token
        SecureRandom.urlsafe_base64
    end

    def downcase_email
        self.email = email.downcase
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,  User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    def create_new_email_digest
        self.confirmation_token = User.new_token
        update_attribute(:confirmation_digest,  User.digest(confirmation_token))
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    private

    def downcase_email
        self.email = email.downcase
    end

    def create_confirmation_digest
        self.confirmation_token = User.new_token
        self.confirmation_digest = User.digest(confirmation_token)
    end
end
