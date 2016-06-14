require 'rails_helper'

feature 'Member can update their profile' do

  signed_in_as(:member) do
    before do
      click_header_option("My Profile")
    end

    scenario 'With valid data' do
      fill_in("Email", with: "valid@example.com")
      fill_in("Current password", with: "password")
      click_button("Update")

      # User should be saved
      click_header_option("My Profile")
      expect(current_user.reload.email).to eq("valid@example.com")
    end

    scenario 'With invalid data' do
      fill_in("Email", with: "")
      click_button("Update")

      expect(page).to have_error_message(:email, "can't be blank")
    end
  end
end
