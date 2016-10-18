FactoryGirl.define do
  factory :list do
    name { FFaker::Lorem.phrase }
    user
    gift_day { 20.days.from_now }
    gift_value { rand(1..9999) }

    trait :with_santas do
      after(:create) do |list|
        FactoryGirl.create_list(:santa, 8, list_id: list.id)
      end
    end
  end
end
