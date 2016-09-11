require 'rails_helper'

feature 'Member can edit an existing list' do
  let!(:list) { FactoryGirl.create(:list, user_id: user.id) }
  let!(:user) { FactoryGirl.create(:user, :member) }

  background do
    sign_in_as(user)
    visit member_dashboard_index_path
  end

  scenario 'Member updates an existing list with valid data' do
    within "table" do
      click_on("Edit")
    end
    fill_in("Name", with: "Winter is coming")
    fill_in_valid_gift_date
    click_on("Update List")

    expect(page.find('.alert.alert-success')).to have_content("List was successfully updated.")
    within "table" do
      expect(page).to have_content("Winter is coming")
    end
    expect(List.count).to eq(1)
  end

  scenario 'Member updates list with invalid data' do
    within "table" do
      click_on("Edit")
    end
    fill_in("Name", with: "")
    fill_in_invalid_gift_date
    click_on("Update List")

    expect(page.find('.alert.alert-danger')).to have_content("List could not be updated. Please address the errors below.")
    expect(page).to have_content("can't be blank")
    click_on("Go back")
    expect(current_path).to eq(member_dashboard_index_path)
  end

  context "the gift day has passed" do
    scenario "user cannot update list" do
      list.update_attributes(gift_day: Date.yesterday)

      within "table" do
        click_on("Edit")
      end

      expect(page.find('.alert.alert-warning')).to have_content("Sorry! You can no longer modify or delete this list! Either the list is locked or the gift day has passed.")
      expect(page).to have_content(list.name)
    end
  end
end
