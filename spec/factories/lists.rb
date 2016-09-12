FactoryGirl.define do
  factory :list do
    name { FFaker::Lorem.phrase }
    user
    gift_day { 20.days.from_now }
    gift_value { rand(0..9999) }
  end
end
