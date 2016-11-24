require 'rails_helper'

RSpec.describe List::ShuffleAndAssignSantas do
  describe '#assign_and_email' do
    subject { List::ShuffleAndAssignSantas.new(test_list.reload).assign_and_email }

    let!(:test_list)   { FactoryGirl.create(:list) }
    let!(:santas) { FactoryGirl.create_list(:santa, 5, list: test_list) }

    scenario 'all santas are assigned a recipient and no santa is unassigned' do
      subject
      givers = []
      santas.each do |santa|
        # Here we ensure each santa is assigned a recipient.
        expect(santa.reload.giving_to).to_not be_nil
        givers << santa.email
      end
      # Here we ensure that all the givers are the same size as the list, and
      # that no santa is giving to someone twice.
      givers = givers.uniq
      expect(givers.size).to be(santas.size)
    end

    scenario 'each santa should recieve an email', sidekiq: :inline do
      expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(5)
    end

    scenario 'the list should be locked after the method runs' do
      expect(test_list.is_locked).to be_falsey
      subject
      expect(test_list.is_locked).to be_truthy
    end
  end
end
