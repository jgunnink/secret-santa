FactoryGirl.define do

  factory :santa do
    name  { FFaker::Lorem.word }
    email { FFaker::Internet.email }
    list
  end

end
