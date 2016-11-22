FactoryGirl.define do

  factory :processed_transaction do
    list
    transaction_id { ["08156329954HRT119", "12134RDFGRFD119", "08234ERDSDFG312119", "32123RTFRC123419"].sample }
  end

end
