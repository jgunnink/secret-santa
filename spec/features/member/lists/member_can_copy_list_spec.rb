require "rails_helper"

feature "Member can copy an existing list" do
  let!(:list) { FactoryGirl.create(:list, :with_santas, user_id: user.id) }
  let!(:user) { FactoryGirl.create(:user, :member) }

  background { sign_in_as(user) }

  shared_examples_for "copying the list details" do
    scenario "the member can access the Copy button and clone the list" do
      within "table" do
        within_row(list.name) { click_on "Copy"}
      end

      expect(page).to have_flash :success, "List was successfully copied. Please update details below."
      expect(List.count).to eq(2)

      original_first_santa = list.santas.order(name: :asc).first
      copied_first_santa = List.order(created_at: :asc).last.santas.order(name: :asc).first
      expect(original_first_santa.name).to eq(copied_first_santa.name)
      expect(original_first_santa.email).to eq(copied_first_santa.email)
      expect(Santa.count).to eq(list.santas.count * 2)
    end
  end

  context "the list is locked" do
    background do
      list.update_attribute(:is_locked, true)
      visit member_dashboard_index_path
    end

    it_behaves_like "copying the list details"
  end

  context "the gift day is in the past" do
    background do
      list.update_attribute(:gift_day, Date.yesterday)
      visit member_dashboard_index_path
    end

    it_behaves_like "copying the list details"
  end

  context "the gift day has not yet occured and the list is not locked" do
    background do
      list.update_attribute(:is_locked, false)
      list.update_attribute(:gift_day, Date.tomorrow)
      visit member_dashboard_index_path
    end

    scenario "member cannot see the Copy button" do
      within "table" do
        within_row(list.name) do
          expect(page).to_not have_link("Copy")
        end
      end
    end
  end
end
