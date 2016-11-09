require 'rails_helper'

feature 'Admin can update an existing User' do

  signed_in_as(:admin) do
    let!(:target_user) { FactoryGirl.create(:user, :admin, email: "something@nothing.com") }

    before do
      click_header_option("Administration")
      click_on("Admins")
      within_row(target_user.email) do
        click_link("Edit")
      end
    end

    scenario 'Admin updates user with valid data' do
      fill_in("Email", with: "valid@example.com")
      fill_in("Given names", with: "Jean-Klaas")
      click_button("Update User")

      # Current user should be redirected to the index
      expect(current_path).to eq(admin_admins_path)

      # Email will not change until confirmed
      expect(target_user.reload.email).to eq("something@nothing.com")
      # User should be saved
      expect(target_user.reload.given_names).to eq("Jean-Klaas")
    end

    scenario 'Admin updates user with invalid data' do
      fill_in("Email", with: "")
      fill_in("Given names", with: "")
      click_button("Update User")

      # Ensure user is not updated
      expect(page).to have_content("User could not be updated.")
      expect(target_user.reload.email).to eq("something@nothing.com")
      expect(page).to have_content("can't be blank")
      expect(page).to have_css(".form-group.string.required.user_given_names.has-error")
    end
  end
end
