require 'rails_helper'

feature 'Admin can view an index of users' do
  signed_in_as(:admin) do
    let!(:member) { FactoryBot.create(:user, :member) }

    before do
      click_header_option("Administration")
      click_on("Members")
    end

    scenario "Showing members" do
      expect(page).to have_content(member.email)
      expect(page).not_to have_content(current_user.email)
    end
  end
end
