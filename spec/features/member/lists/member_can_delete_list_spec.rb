require 'rails_helper'

feature 'Member can delete an existing list' do

  let!(:list) { FactoryGirl.create(:list, user_id: user.id) }
  let!(:user) { FactoryGirl.create(:user, :member) }

  background do
    sign_in_as(user)
    visit member_dashboard_index_path
  end

  scenario "signed in user deletes existing list" do

    #ensure list exists before attempting to delete.
    expect(page).to have_content(list.name)

    within "table" do
      click_on("Delete")
    end

    expect(page).to have_flash(:notice, "List was successfully deleted")
    expect(page).to_not have_content(list.name)
    expect(page).to have_content("You have no secret santa lists yet!")
  end

end
