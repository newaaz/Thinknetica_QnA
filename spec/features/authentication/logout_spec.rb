require 'rails_helper'

feature 'User can logout', %q{
  In order to log out from system
  As an authenticated user
  I'd like to be able to log out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries log out' do
    sign_in(user)
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries log out' do
    visit root_path
    expect(page).to_not have_content 'Logout'      
  end
end
