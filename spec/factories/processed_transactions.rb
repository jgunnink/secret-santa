FactoryGirl.define do

  factory :processed_transaction do
    list
    transaction_id { FFaker::Color.hex_code }
  end

end
