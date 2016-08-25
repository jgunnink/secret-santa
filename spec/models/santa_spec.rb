require 'rails_helper'

RSpec.describe Santa do

  describe "@name" do
    it { should validate_presence_of(:name) }
  end

  describe "@list" do
    it { should validate_presence_of(:list) }
    it { should belong_to(:list).inverse_of(:santas) }
  end

  describe "@email" do
    # this record is required for the uniqueness matcher
    let!(:santa) { FactoryGirl.create(:santa) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).scoped_to(:list_id) }
  end

end
