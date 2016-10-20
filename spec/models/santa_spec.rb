require 'rails_helper'

RSpec.describe Santa do

  describe '@name' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(20) }
  end

  describe '@list' do
    it { should validate_presence_of(:list) }
    it { should belong_to(:list).inverse_of(:santas) }
  end

  describe '@email' do
    # this record is required for the uniqueness matcher
    subject { FactoryGirl.build(:santa) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).scoped_to(:list_id) }
  end

end
