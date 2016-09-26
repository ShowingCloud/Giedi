class PhoneVerification < ActiveRecord::Base
  validates :phone, presence: true, uniqueness:true
  validates :pin, presence: true
end
