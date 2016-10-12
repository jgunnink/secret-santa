require 'rails_helper'

feature "User can access home page" do
  background { visit root_path }

  scenario "when the user is not signed in" do
    expect(page).to have_link "Create your first list!"
    expect(page).to have_link "Already an organiser? Sign in"
    expect(page).to_not have_link "Go to your dashboard"
  end

  scenario "when signed in" do
    sign_in_as(:member) do
      expect(page).to have_link "Go to your dashboard"
      expect(page).to_not have_link "Create your first list!"
      expect(page).to_not have_link "Already an organiser? Sign in"
    end
  end
end
