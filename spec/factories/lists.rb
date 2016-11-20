FactoryGirl.define do
  factory :list do
    # Using City as it's the most suitable for the length validations.
    name { FFaker::AddressAU.city }
    user
    gift_day { 20.days.from_now }
    gift_value { rand(1..9999) }

    trait :with_santas do
      after(:create) do |list|
        FactoryGirl.create_list(:santa, 8, list_id: list.id)
      end
    end

    trait :paid do
      limited { false }
    end

    trait :unpaid do
      limited { true }
    end
  end
end
