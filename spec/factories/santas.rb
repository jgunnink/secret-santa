FactoryGirl.define do

  factory :santa do
    name  { FFaker::Lorem.phrase }
    email { FFaker::Internet.email }
    list
  end

end
