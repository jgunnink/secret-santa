FactoryGirl.define do

  factory :user do
    email    { FFaker::Internet.email }
    password "password"
    role :member
    given_names { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    confirmed_at { Time.current }

    trait :admin do
      role :admin
    end

    trait :member do
      role :member
    end
  end

end
