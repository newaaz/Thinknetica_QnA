require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question
  As anquestion's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/newaaz/78edbf7ec647d87cacd1bffa2a51b3ad' }

  background do
    sign_in(user)
    visit question_path question

    find('.answer-form').fill_in 'Body', with: 'Correct answer - you need update gem'
  end

  scenario 'User add links when create answer', js: true do    
    within '.answer-form' do      
      click_on 'add link'      

      page.all('.nested-fields').each do |field|
        within(field) do
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url
        end
      end  
  
      click_on 'Add answer'
    end     
    
    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url, count: 2
    end
  end

  scenario 'User add invalid link when create answer', js: true do
    within '.answer-form' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'wrong url'
      
      click_on 'Add answer'

      expect(page).to have_content "Invalid url"
    end
  end

  scenario 'User links to non-existent page when create a question', js: true do
    within '.answer-form' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'https://wrongsite/wrongsite/78edbf7ec647d87cacd1bffa2a51b3ad'

      click_on 'Add answer'
      sleep 0.5
      expect(page).to have_content "This page does not exist"
    end
  end
end

