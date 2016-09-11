FactoryGirl.define do
  factory :list do
    name { FFaker::Lorem.phrase }
    user
    gift_day { 20.days.from_now }
    gift_value { rand(0.00..9999.99) }
  end
end
