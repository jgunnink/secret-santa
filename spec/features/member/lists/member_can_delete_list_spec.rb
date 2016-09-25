require 'rails_helper'

feature 'Member can delete an existing list' do

  let!(:list) { FactoryGirl.create(:list, user_id: user.id) }
  let!(:user) { FactoryGirl.create(:user, :member) }

  background do
    sign_in_as(user)
    visit member_dashboard_index_path
  end

  scenario 'signed in user deletes existing list' do
    # Ensure list exists before attempting to delete.
    expect(page).to have_content(list.name)

    within 'table' do
      click_on('Delete')
    end

    expect(page).to have_flash :success, 'List was successfully deleted'
    expect(page).to_not have_content(list.name)
    expect(page).to have_content('You have no secret santa lists yet!')
  end

  context 'the gift day has passed' do
    before { list.update_attribute(:gift_day, Date.yesterday) }

    scenario 'user cannot delete list' do
      within 'table' do
        click_on('Delete')
      end

      expect(page).to have_flash :warning, 'Sorry! You can no longer modify or delete this list! Either the list is locked or the gift day has passed.'
      expect(page).to have_content(list.name)
    end
  end

  context 'the list has been locked' do
    before { list.update_attribute(:is_locked, true) }

    scenario 'user cannot delete list' do
      within 'table' do
        click_on('Delete')
      end

      expect(page).to have_flash :warning, 'Sorry! You can no longer modify or delete this list! Either the list is locked or the gift day has passed.'
      expect(page).to have_content(list.name)
    end
  end

end
