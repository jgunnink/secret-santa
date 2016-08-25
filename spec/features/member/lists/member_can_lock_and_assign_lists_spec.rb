require 'rails_helper'

feature 'Member can lock and assign santas within a list' do

  let(:list)   { FactoryGirl.create(:list, user_id: user.id) }
  let(:user)   { FactoryGirl.create(:user, :member) }
  let!(:santas) { FactoryGirl.create_list(:santa, 5, list_id: list.id)}

  background do
    sign_in_as(user)
    visit member_list_path(list)
  end

  scenario 'user can lock the list and assign users', :js do
    expect(page).to have_button('Lock, assign and send')
    expect(page).to_not have_content('Not available if there are less than three (3) Santas in your list')

    click_on('Lock, assign and send')
    page.driver.browser.accept_confirm

    expect(page).to have_flash :success, 'Recipients set and Santas notified'
  end

  context 'where there are fewer than 3 santas in a list' do
    let!(:santas) { FactoryGirl.create_list(:santa, 2, list_id: list.id)}

    scenario 'the button should be disabled, with information' do
      expect(page).to have_button('Lock, assign and send', disabled: true)
      expect(page).to have_content('Not available if there are less than three (3) Santas in your list')
    end
  end

end
