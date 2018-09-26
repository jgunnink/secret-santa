require 'rails_helper'

feature 'Admin can delete an existing User' do

  signed_in_as(:admin) do
    let!(:target_user) { FactoryBot.create(:user, email: "something@nothing.com") }

    before do
      click_header_option("Administration")
      click_on("Members")
    end

    scenario 'Admin can delete user' do
      within_row(target_user.email) do
        click_link("Delete")
      end

      # User should be deleted
      expect(target_user.reload).to be_deleted
      expect(page.find('.alert.alert-success')).to have_content("'something@nothing.com' deleted")
    end
  end
end
