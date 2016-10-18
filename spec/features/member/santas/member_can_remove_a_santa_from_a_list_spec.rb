require 'rails_helper'

feature 'a member can remove a santa from a list', :js do

  signed_in_as(:member) do

    let!(:list)  { FactoryGirl.create(:list, user: current_user) }
    let!(:santa) { FactoryGirl.create(:santa, list: list) }

    scenario 'member edits list and removes santa' do
      visit member_dashboard_index_path
      within "table" do
        within_row(list.name) { click_on("Add Santas") }
      end

      within "#santas" do
        click_on("Remove Santa")
      end

      click_on("Save Santas")

      expect(page.find('.alert.alert-success')).to have_content("List was successfully updated.")
      expect(Santa.first).to be_nil
    end
  end

end
