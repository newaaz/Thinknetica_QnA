require 'rails_helper'

feature 'User can answer the question', %q{
  In order to help with problem
  As an authenticated user
  I'd like to be able to create answer on question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path question
    end

    scenario 'answers the question' do      
      fill_in 'Body', with: 'Correct answer - you need update gem'
      click_on 'Add answer'
  
      expect(page).to have_content 'Your answer successfully added'
      expect(page).to have_content 'Correct answer - you need update gem'
    end
  
    scenario 'answers the question with errors' do
      click_on 'Add answer'
      expect(page).to have_content 'error(s) detected:'
    end
  end

  scenario 'Unauthenticated user answers the question' do
    visit question_path question
    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
