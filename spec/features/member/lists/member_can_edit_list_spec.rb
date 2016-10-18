require "rails_helper"

feature "Member can edit an existing list" do
  let!(:list) { FactoryGirl.create(:list, user_id: user.id) }
  let!(:user) { FactoryGirl.create(:user, :member) }

  background do
    sign_in_as(user)
    visit member_dashboard_index_path
  end

  scenario "Member updates an existing list with valid data" do
    within "table" do
      click_on("Edit")
    end
    fill_in("Name", with: "Winter is coming")
    fill_in("Gift value", with: 95)
    fill_in_valid_gift_date
    click_on("Update List")

    expect(page).to have_flash :success, "List was successfully updated."
    within "table" do
      expect(page).to have_content("Winter is coming")
    end
    expect(List.count).to eq(1)
  end

  scenario "Member updates list with invalid data" do
    within "table" do
      click_on("Edit")
    end
    fill_in("Name", with: "")
    fill_in("Gift value", with: 10000)
    fill_in_invalid_gift_date
    click_on("Update List")

    expect(page).to have_flash :danger, "List could not be updated. Please address the errors below."
    expect(page).to have_content("can't be blank")
    expect(page).to have_content("You can't set the gift day to be today or in the past")
    click_on("Go back")
    expect(current_path).to eq(member_dashboard_index_path)
  end

  context "the list is locked" do
    before { list.update_attribute(:is_locked, true) }

    scenario "user cannot edit list" do
      visit edit_member_list_path(list)

      expect(page).to have_flash :warning, "Sorry! You can no longer modify this list! The list has been locked and Santas notified."
      expect(page).to have_content(list.name)
    end
  end
end
