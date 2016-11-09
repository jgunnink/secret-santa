require 'rails_helper'

feature 'Member can update their profile' do

  let(:member) { FactoryGirl.create(:user, :member, email: "jk@example.com") }

  background do
    sign_in_as(member)
    click_header_option("My Profile")
  end

  scenario 'With valid data' do
    fill_in("Email", with: "valid@example.com")
    fill_in("Current password", with: "password")
    click_button("Update")

    # Email will not change until confirmed
    expect(member.email).to eq("jk@example.com")
    expect(page).to have_flash :success, "You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address."
  end

  scenario 'With invalid data' do
    fill_in("Email", with: "")
    click_button("Update")

    expect(page).to have_content("can't be blank")
  end
end
