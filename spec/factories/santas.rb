FactoryBot.define do

  factory :santa do
    name  { FFaker::Name.first_name }
    email { FFaker::Internet.email }
    list
  end

end
