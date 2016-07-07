class User < ActiveRecord::Base
  has_secure_password
  validates :name, presence: true
  validates :phone, presence: true, unless: ->(user){user.email.present?}
  validates :email, presence: true, unless: ->(user){user.phone.present?}
end
