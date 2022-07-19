require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions and answer questions
  As an unregistered user
  I'd like to be able to sign up
} do

  given(:user) { build(:user) }

  scenario 'Unregistered user tries to sign up' do
    complete_registration

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with errors' do
    visit new_user_registration_path
    click_on 'Sign up'

    expect(page).to have_content 'prohibited this user from being saved:'
  end  

  scenario 'Registered user tries to sign up' do
    complete_registration
    click_on 'Logout'
    complete_registration
    
    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Authenticated user tries to sign up' do
    complete_registration
    visit new_user_registration_path

    expect(page).to have_content 'You are already signed in.'
  end

  def complete_registration
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
  end
end
