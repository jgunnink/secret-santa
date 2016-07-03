require 'rails_helper'

feature 'member can update santas on a list', :js do

  signed_in_as(:member) do

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

        click_on("Save Changes")

        expect(page).to have_flash(:notice, "List was successfully updated.")
        expect(Santa.first.email).to eq("littlejohnny@example.com")
      end
    end

  end

end
