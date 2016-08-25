require "rails_helper"

feature "Member can view an existing list" do

  let!(:list)  { FactoryGirl.create(:list, user_id: user.id) }
  let!(:user)  { FactoryGirl.create(:user, :member) }
  let!(:santa) { FactoryGirl.create(:santa, list: list) }

  background do
    sign_in_as(user)
    visit member_dashboard_index_path
  end

  scenario "signed in user can view existing list" do
    within "table" do
      click_on("View")
    end

    expect(page).to have_content("Viewing list: #{list.name}")

    within "table" do
      expect(page).to have_content(santa.name)
      expect(page).to have_content(santa.email)
    end
  end

end
