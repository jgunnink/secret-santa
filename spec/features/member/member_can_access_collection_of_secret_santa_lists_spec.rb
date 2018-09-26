require 'rails_helper'

feature 'Member can access a collection of their lists' do

  signed_in_as(:member) do

    context 'User already has created some lists' do
      let!(:list) { FactoryBot.create(:list, user_id: current_user.id) }

      scenario 'it should return a collection of lists for the current user' do
        visit member_dashboard_index_path
        within 'table' do
          expect(page).to have_content(list.name)
        end
      end
    end

    context 'User has not yet created a list' do
      scenario 'it should tell the user there is no list present' do
        visit member_dashboard_index_path
        expect(page).to have_content("You have no secret santa lists yet!")
      end
    end

  end
end
