require "rails_helper"

feature "member can add santas to a list", :js do

  signed_in_as(:member) do

    context "a list does not yet exist" do
      background do
        visit member_dashboard_index_path
        click_on("Add new list")
        fill_in("Name", with: "Winter is coming")
        fill_in_valid_gift_date
        click_on "Create List"
      end

      scenario "Member adds new list with valid data" do
        within "#santas" do
          click_on("Add Santa")
          fill_in("Name", with: "Johnny")
          fill_in("Email", with: "littlejohnny@example.com")
        end
        click_on "Save Santas"

        expect(page).to have_flash :success, "List was successfully updated."
        expect(List.count).to be(1)
        expect(List.order(:created_at).last.santas.count).to be(1)
        within "table" do
          within_row("Winter is coming") { click_on("Review List and Send") }
          expect(page).to have_content("littlejohnny@example.com")
        end
      end

      scenario "Member adds new list with invalid data" do
        within "#santas" do
          click_on("Add Santa")
          fill_in("Name", with: "")
          fill_in("Email", with: "not an email")
        end
        click_on "Save Santas"

        # When the form is submitted, the page will pop up a HTML form helper
        # which tells the user the form coulnd't be submitted because of
        # incorrect values on the page. So our expectation here is to assume the
        # Santa count remains at zero for that list.
        expect(List.order(:created_at).last.santas.count).to be(0)
      end

    end

    context "a list already exists" do
      let!(:list) { FactoryGirl.create(:list, user: current_user) }

      scenario "Member edits list and adds a santa" do
        visit member_dashboard_index_path
        within "table" do
          within_row(list.name) { click_on("Add Santas") }
        end

        within "#santas" do
          click_on("Add Santa")
          within ".nested-fields:nth-child(1)" do
            fill_in("Name", with: "Johnny")
            fill_in("Email", with: "littlejohnny@example.com")
          end

          # An issue with cocoon builds two children when the page is opened.
          # So we remove the second here, and then make our assertions.
          within(".nested-fields:nth-child(2)") { click_on "Remove Santa" }
        end

        click_on("Save Santas")

        expect(page).to have_flash :success, "List was successfully updated."
        expect(Santa.first.email).to eq("littlejohnny@example.com")
      end
    end

  end

end
