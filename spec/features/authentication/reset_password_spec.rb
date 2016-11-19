require 'rails_helper'

feature 'Existing users can reset their passwords' do
  let(:user) { FactoryGirl.create(:user) }

  background do
    visit root_path
    within('nav') { click_link 'Sign in' }
    click_link 'Forgot your password?'
  end

  scenario 'User enters a valid email address' do
    fill_in 'Email', with: user.email
    submit_form

    expect(page).to have_content "You will receive an email with instructions on how to reset your password in a few minutes."
    expect(page).to_not have_content "Hash was successfully created."

    open_email(user.email)
    visit_in_email 'Change my password'

    fill_in 'New password', with: 'password'
    fill_in 'Confirm new password', with: 'password'
    submit_form

    expect(page).to have_content("Your password was changed successfully. You are now signed in.")
  end

  scenario 'User enters an invalid email address' do
    fill_in 'Email', with: 'fake@email.com'
    submit_form
    within("form") do
      # Errors show below the inputs, Capybara will show the error as follows
      expect(page).to have_content("Emailnot found")
    end
  end
end
