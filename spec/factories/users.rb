FactoryGirl.define do
  factory :user do
    name  {Faker::Internet.user_name}
    password  {Faker::Internet.password }
    email {Faker::Internet.email}

    factory :invalid_user do
      name nil
    end

    factory :phone_user do
      phone "18035243428"
      email nil
    end
  end
end
