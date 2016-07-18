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

    expect(page.find('.alert.alert-success')).to have_content("List was successfully deleted")
    expect(page).to_not have_content(list.name)
    expect(page).to have_content("You have no secret santa lists yet!")
  end

  context "the gift day has passed" do
    scenario "user cannot delete list" do
      list.update_attributes(gift_day: Date.yesterday)

      within "table" do
        click_on("Delete")
      end

      expect(page.find('.alert.alert-warning')).to have_content("Sorry! As the gift day has passed, you can no longer modify or delete this list!")
      expect(page).to have_content(list.name)
    end
  end

end
