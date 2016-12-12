require "rails_helper"

feature "Member reveal list to show santas", :js do
  let(:list)    { FactoryGirl.create(:list, user_id: user.id) }
  let(:user)    { FactoryGirl.create(:user, :member) }
  let!(:santas) { FactoryGirl.create_list(:santa, 5, list_id: list.id) }

  background do
    sign_in_as(user)
    visit member_list_path(list)
    click_on('Lock, assign and send')
    within('.modal-footer') do
      click_on('Lock, assign and send')
    end
  end

  scenario "member clicks reveal button to show who has been assigned to who" do
    click_on "Reveal List"

    expect(page).to have_flash :success, "List has been revealed!"

    within "table" do
      expect(page).to have_content "Giving to"
      within_row(list.reload.santas.first.email) do
        expect(page).to have_content(list.santas.first.recipient.name)
      end
    end
  end
end
