require "rails_helper"

feature "member can update santas on a list", :js do
  signed_in_as(:member) do

    context "a list already exists" do
      let!(:list) { FactoryGirl.create(:list, user: current_user) }

      scenario "Member edits list and adds a santa" do
        visit member_dashboard_index_path
        within_row(list.name) { click_on("Add Santas") }

        within "#santas" do
          click_on("Add Santa")
          within(".nested-fields:nth-child(1)") do
            fill_in("Name", with: "Johnny")
            fill_in("Email", with: "littlejohnny@example.com")
          end
        end
        click_on "Save Santas"

        expect(page).to have_flash :success, "List was successfully updated."
        expect(Santa.first.email).to eq("littlejohnny@example.com")
      end

      scenario "Member edits list with invalid data" do
        visit member_dashboard_index_path
        within "table" do
          within_row(list.name) { click_on("Add Santas") }
        end

        within "#santas" do
          click_on("Add Santa")
          within(".nested-fields:nth-child(1)") do
            fill_in("Name", with: "")
            fill_in("Email", with: "not an email")
          end
        end

        click_on "Save Santas"

        # When the form is submitted, the page will pop up a HTML form helper
        # which tells the user the form coulnd't be submitted because of
        # incorrect values on the page. So our expectation here is to assume the
        # Santa count remains at zero for that list.
        expect(List.order(:created_at).last.santas.count).to be(0)
      end
    end

  end
end
