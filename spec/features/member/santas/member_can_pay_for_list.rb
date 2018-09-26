require "rails_helper"

feature "member can make payment for a list", :js do
  signed_in_as(:member) do

    background { visit member_list_santas_path(list) }

    context "where the user has not paid" do
      let!(:list) { FactoryBot.create(:list, :unpaid, user: current_user) }

      scenario "the buy now button shows" do
        within ".panel-body" do
          expect(page).to have_content "Buy Now"
        end
      end

      scenario "the blurb showing supporting the site is shown" do
        within ".panel-body" do
          expect(page).to have_content "Currently, all lists are capped at a maximum of 15."
          expect(page).to_not have_content "Thank you for your support! You can add as many Santas as you need in the list."
        end
      end
    end

    context "where the user has paid" do
      let!(:list) { FactoryBot.create(:list, :paid, user: current_user) }

      scenario "the buy now button is hidden" do
        within ".panel-body" do
          expect(page).to_not have_content "Buy Now"
        end
      end

      scenario "the blurb showing supporting the site is shown" do
        within ".panel-body" do
          expect(page).to_not have_content "Currently, all lists are capped at a maximum of 15."
          expect(page).to have_content "Thank you for your support! You can add as many Santas as you need in the list."
        end
      end
    end
  end
end
