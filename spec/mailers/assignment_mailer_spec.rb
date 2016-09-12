require 'rails_helper'

describe AssignmentMailer do
  describe '#notify_approved_users_of_new_event_update' do
    subject(:email_user) { AssignmentMailer.send_assignment(santa) }

    let!(:other_santa) { FactoryGirl.create(:santa) }
    let!(:santa) do
      FactoryGirl.create(:santa,
                         list: other_santa.list,
                         giving_to: other_santa.id)
    end
    let!(:list) { santa.list }

    it { should deliver_from('Captain Santa <santa@secretsanta.com>') }
    it { should have_subject "Your Secret Santa for #{list.name}" }
    it { should have_content "Dear #{santa.name}" }
    it { should have_content "You're on the list for #{list.name}" }
    it { should have_content "You are a Secret Santa for #{other_santa.name}" }
    it { should have_content "#{list.user.given_names}, has set the day" }
    it { should have_content list.gift_day.strftime('%A, %B %-d, %Y') }

    scenario "where the gift value has been set" do
      list.update_attributes(gift_value: 20)

      should have_content "value set by #{list.user.given_names}"
      should have_content "is: $20"
    end

    scenario "where the gift value has been set" do
      list.update_attributes(gift_value: nil)

      should_not have_content "value set by #{list.user.given_names}"
    end
  end
end
