require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As anquestion's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/newaaz/78edbf7ec647d87cacd1bffa2a51b3ad' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit questions_path
      click_on 'Ask question'
    end
  
    scenario 'Create a question' do
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question body'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      
      click_on 'Ask'
  
      expect(page).to have_link 'My gist', href: gist_url
    end
  end


end

