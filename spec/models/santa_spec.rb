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
    subject { FactoryBot.build(:santa) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).scoped_to(:list_id) }

    context "testing validity of email address with regex matcher" do
      let!(:santa) { FactoryBot.build(:santa, email: email) }

      context "where the email is abc@example.com" do
        let(:email) { "abc@example.com" }
        specify { expect(santa).to be_valid }
      end

      context "where the email is q@123.com" do
        let(:email) { "q@123.com" }
        specify { expect(santa).to be_valid }
      end

      context "where the email is user@staff.secretsanta.website" do
        let(:email) { "user@staff.secretsanta.website" }
        specify { expect(santa).to be_valid }
      end

      context "where the email is user@secret-staff.secretsanta.website" do
        let(:email) { "user@secret-staff.secretsanta.website" }
        specify { expect(santa).to be_valid }
      end

      context "where the email is craig@gmail" do
        let(:email) { "craig@gmail" }
        specify { expect(santa).to_not be_valid }
      end

      context "where the email is someone@example.c" do
        let(:email) { "someone@example.c" }
        specify { expect(santa).to_not be_valid }
      end

      context "where the email is (&^%(@example.com" do
        let(:email) { "(&^%(@example.com" }
        specify { expect(santa).to_not be_valid }
      end
    end
  end

end
