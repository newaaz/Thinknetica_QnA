require 'rails_helper'

feature 'User can signin with oauth services', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in with oauth services
} do  
  
  background { visit new_user_session_path }

  scenario 'Signin with provider with email' do
    mock_auth_hash(:github, 'github@user.com')       
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account.'
    expect(page).to have_content 'github@user.com'
  end

  scenario 'Signin with provider without email' do
    mock_auth_hash(:vkontakte)
    click_on 'Sign in with Vkontakte'

    fill_in 'user_email', with: 'vkontakte@user.com'
    click_on 'Send'

    open_email('vkontakte@user.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
