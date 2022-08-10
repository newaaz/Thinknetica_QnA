require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question
  As anquestion's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/newaaz/78edbf7ec647d87cacd1bffa2a51b3ad' }

  scenario 'User adds link when create answer', js: true do
    sign_in(user)

    visit question_path question
    
    within '.answer-form' do
      fill_in 'Body', with: 'Correct answer - you need update gem'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
  
      click_on 'Add answer'
    end     
    
    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end  
end

