FactoryGirl.define do
  factory :list do
    name FFaker::Lorem.phrase
    user
    gift_day 20.days.from_now
  end
end
