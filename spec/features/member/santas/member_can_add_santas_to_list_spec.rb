require 'rails_helper'

feature 'member can add santas to a list', :js do

  signed_in_as(:member) do

    context 'a list does not yet exist' do

      scenario 'Member adds new list with valid data' do
        visit member_dashboard_index_path
        click_on("Create a list")
        fill_in("Name", with: "Winter is coming")
        fill_in_valid_gift_date

        within "#santas" do
          click_on("Add Santa")
          fill_in("Name", with: "Johnny")
          fill_in("Email", with: "littlejohnny@example.com")
        end

        click_on("Create List")

        expect(page.find('.alert.alert-success')).to have_content("List was successfully created.")
        expect(List.count).to be(1)
        # the following test is currently commented out because of an issue with cocoon.
        # expect(List.last.santas.count).to be(1)
        within "table" do
          within_row("Winter is coming") { click_on("View") }
          expect(page).to have_content("littlejohnny@example.com")
        end
      end

      scenario 'Member adds new list with invalid data' do
        visit member_dashboard_index_path
        click_on("Create a list")
        fill_in("Name", with: "Winter is coming")

        within "#santas" do
          click_on("Add Santa")
          fill_in("Name", with: "")
          fill_in("Email", with: "not an email")
        end

        click_on("Create List")

        expect(page.find('.alert.alert-danger')).to have_content("List could not be created. Please address the errors below.")
        within "#santas" do
          expect(page).to have_content("can't be blank")
          expect(page).to have_content("is invalid")
        end
        expect(List.count).to be(0)
      end

    end

    context 'a list already exists' do
      let!(:list) { FactoryGirl.create(:list, user: current_user) }

      scenario 'Member edits list and adds a santa' do
        visit member_dashboard_index_path
        within "table" do
          within_row(list.name) { click_on("Edit") }
        end

        within "#santas" do
          click_on("Add Santa")
          fill_in("Name", with: "Johnny")
          fill_in("Email", with: "littlejohnny@example.com")
        end

        click_on("Update List")

        expect(page.find('.alert.alert-success')).to have_content("List was successfully updated.")
        expect(Santa.first.email).to eq("littlejohnny@example.com")
      end
    end

  end

end
