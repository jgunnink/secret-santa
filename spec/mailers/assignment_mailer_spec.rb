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

    it { should deliver_from('Captain Santa <santa@secretsanta.com>') }
    it { should have_subject "Your Secret Santa for #{santa.list.name}" }
    it { should have_content "Dear #{santa.name}" }
    it { should have_content "You're on the list for #{santa.list.name}" }
    it { should have_content "You are a Secret Santa for #{other_santa.name}" }
    it { should have_content "#{santa.list.user.given_names}, has set the day" }
    it { should have_content santa.list.gift_day.strftime('%A, %B %-d, %Y') }
  end
end
