require 'rails_helper'

RSpec.describe List do

  describe '@name' do
    it { should validate_presence_of(:name) }
  end

  describe "@santas" do
    let!(:list) { FactoryGirl.create(:list) }
    let!(:santa) { FactoryGirl.create(:santa, list_id: list.id) }

    it "deletes associated lists if the user account is deleted" do
      expect { list.destroy }.to change { Santa.count }.by(-1)
    end
  end

end
