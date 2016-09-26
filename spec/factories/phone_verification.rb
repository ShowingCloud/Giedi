FactoryGirl.define do
  factory :phone_verification do
    phone "18035243428"
    pin {Faker::Number.number(6)}
  end
end
