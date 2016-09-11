require 'rails_helper'

feature 'Admin can view an index of users' do
  signed_in_as(:admin) do
    let!(:other_admin) { FactoryGirl.create(:user, :admin) }
    let!(:member)      { FactoryGirl.create(:user, :member) }

    before do
      click_header_option("Administration")
      click_on("Admins")
    end

    scenario "Showing admins" do
      expect(page).to have_content(other_admin.email)
      expect(page).not_to have_content(member.email)
    end
  end
end
