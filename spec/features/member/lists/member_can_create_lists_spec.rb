require 'rails_helper'

feature 'Member can create a new list' do

  background { visit member_dashboard_index_path }

  signed_in_as(:member) do

    scenario 'Member adds new list with valid data' do
      click_on("Create a list")
      fill_in("Name", with: "Winter is coming")
      click_on("Create")

      expect(page).to have_flash(:notice, "List was successfully created.")
      within "table" do
        expect(page).to have_content("Winter is coming")
      end
      expect(List.count).to eq(1)
    end

    scenario 'Member adds new list with invalid data' do
      click_on("Create a list")
      fill_in("Name", with: "")
      click_on("Create")

      expect(page).to have_flash(:alert, "List could not be created. Please address the errors below.")
      expect(List.count).to eq(0)
      expect(page).to have_error_message(:name, "can't be blank")
    end

  end

end
