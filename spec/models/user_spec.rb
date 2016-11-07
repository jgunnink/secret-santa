require "rails_helper"

RSpec.describe User do

  describe "@given_names" do
    it { should validate_presence_of(:given_names) }
    it { should validate_length_of(:given_names).is_at_least(2).is_at_most(20) }
  end

  describe "@email" do
    let!(:user)    { FactoryGirl.create(:user) }
    let(:new_user) { FactoryGirl.build(:user, email: user.email) }

    it { should validate_presence_of(:email) }

    it "validates uniqueness with other active users" do
      expect(new_user).to be_invalid
      expect(new_user.errors[:email]).to be_present
    end

    it "doesn't validate uniqueness with deleted users" do
      user.destroy
      expect(new_user).to be_valid
    end

    it "doesn't validate uniqueness of email when both users are deleted" do
      user.destroy
      new_user.save!
      new_user.deleted_at = user.deleted_at
      expect(new_user).to be_valid
    end
  end

  describe "@lists" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:santa_list) { FactoryGirl.create(:list, user_id: user.id) }

    it "deletes associated lists if the user account is deleted" do
      expect { user.destroy }.to change { List.count }.by(-1)
    end
  end

  describe "@password" do
    it { should validate_presence_of(:password) }
  end

  describe "@role" do
    it { should validate_presence_of(:role) }
  end

  describe "#to_s" do
    specify { expect(User.new(email: "yolo").to_s).to eq("yolo") }
  end

end
