FactoryGirl.define do

  factory :list do
    name FFaker::Lorem.phrase
    user
  end

end
