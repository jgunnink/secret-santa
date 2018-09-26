require "rails_helper"

RSpec.describe ProcessedTransaction do

  describe "@list_id" do
    subject { FactoryBot.build(:processed_transaction) }
    it { should validate_presence_of(:list_id) }
    it { should validate_uniqueness_of(:list_id) }
  end

  describe "@transaction_id" do
    subject { FactoryBot.build(:processed_transaction) }
    it { should validate_presence_of(:transaction_id) }
    it { should validate_uniqueness_of(:transaction_id) }
  end

end
