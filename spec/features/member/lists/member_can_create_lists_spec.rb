require "rails_helper"

feature "Member can create a new list" do
  background { visit member_dashboard_index_path }

  signed_in_as(:member) do
    scenario "Member adds new list with valid data" do
      click_on("Add new list")
      fill_in("Name", with: "Winter is coming")
      fill_in("Gift value", with: 20)
      fill_in_valid_gift_date
      click_on("Create List")

      expect(page).to have_flash :success, "List was successfully created."
      expect(List.count).to eq(1)
      # The user is taken to the next page to add santas.
      expect(current_path).to eq(member_list_santas_path(List.order(:created_at).last))
    end

    scenario "Member adds new list with invalid data" do
      click_on("Add new list")
      fill_in("Name", with: "")
      fill_in("Gift value", with: -5)
      fill_in_invalid_gift_date
      click_on("Create List")

      expect(page).to have_flash :danger, "List could not be created. Please address the errors below."
      expect(List.count).to eq(0)
      expect(page).to have_content("can't be blank")
      expect(page).to have_content("must be greater than 0")
    end
  end
end
