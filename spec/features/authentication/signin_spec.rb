require 'rails_helper'

feature 'User can signin', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  # visit login page (background - alias before)
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    # refactor to given
    # User.create!(email: 'user@test.com', password: '12345678')

    # visit login page (refactor to backround)
    # visit new_user_session_path

    # fill fields email, password
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    # open page in browser
    # save_and_open_page
    
    # check successful login
    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: 'wrong'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
  end
end
