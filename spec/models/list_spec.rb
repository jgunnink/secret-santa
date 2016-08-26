require 'rails_helper'

RSpec.describe List do

  describe '@name' do
    it { should validate_presence_of(:name) }
  end

  describe '@santas' do
    it { should have_many(:santas).inverse_of(:list) }
  end

  describe '@gift_day' do
    it { should validate_presence_of(:gift_day) }

    context 'the gift day is set in the past' do
      let!(:list) { FactoryGirl.build(:list, gift_day: Date.yesterday) }

      it 'should not be valid and give errors' do
        expect(list).to_not be_valid
        expect(list.errors[:gift_day]).to be_present
      end
    end

    context 'the gift day is set in the future' do
      let!(:list) { FactoryGirl.build(:list, gift_day: Date.tomorrow) }

      it 'should be valid' do
        expect(list).to be_valid
      end
    end

    context 'the gift day is not set' do
      let!(:list) { FactoryGirl.build(:list, gift_day: nil) }

      it 'should not be valid and give errors' do
        expect(list).to_not be_valid
        expect(list.errors[:gift_day]).to be_present
      end
    end
  end

  describe "@santas" do
    let!(:list) { FactoryGirl.create(:list) }
    let!(:santa) { FactoryGirl.create(:santa, list_id: list.id) }

    it "deletes associated santas if the list is deleted" do
      expect { list.destroy }.to change { Santa.count }.by(-1)
    end
  end

  describe "@cannot_be_changed" do
    let!(:list) { FactoryGirl.create(:list, is_locked: status) }
    let!(:santa) { FactoryGirl.create(:santa, list_id: list.id) }

    context "where the list is locked" do
      let(:status) { true }

      it "should have errors" do
        expect(list).to_not be_valid
        expect(list.errors[:is_locked]).to be_present
        expect(list.errors.first).to include("List has been locked and Santas already emailed.")
      end
    end

    context "where the list is unlocked" do
      let(:status) { false }

      it "should pass validation" do
        expect(list).to be_valid
        expect(list.errors.count).to be(0)
      end
    end
  end

end
