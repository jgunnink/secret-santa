require 'rails_helper'

feature 'Member can lock and assign santas within a list' do
  let(:list)    { FactoryGirl.create(:list, user_id: user.id) }
  let(:user)    { FactoryGirl.create(:user, :member) }
  let!(:santas) { FactoryGirl.create_list(:santa, 5, list_id: list.id) }

  background do
    sign_in_as(user)
    visit member_list_path(list)
  end

  scenario 'user can lock the list and assign users', :js do
    expect(page).to have_button('Lock, assign and send')
    expect(page).to_not have_content('Please add some more Santas to your list. We need at least three.')

    click_on('Lock, assign and send')
    # We click the button again in the modal that has popped up.
    expect(page).to have_content("By proceeding now, your list will be locked!")

    within('.modal-footer') do
      click_on('Lock, assign and send')
    end

    expect(page).to have_flash :success, 'Recipients set and Santas notified'
    expect(page).to have_content('Note: List is locked. Santas have been assigned and emailed.')
  end

  context 'where there are fewer than 3 santas in a list' do
    let!(:santas) { FactoryGirl.create_list(:santa, 2, list_id: list.id) }
    specify { expect(page).to have_content('Please add some more Santas to your list. We need at least three.') }
  end
end
