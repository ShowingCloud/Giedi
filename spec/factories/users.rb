FactoryGirl.define do
  factory :user do
    name  {Faker::Internet.user_name}
    password  {Faker::Internet.password }
    email {Faker::Internet.email}
  end
end
