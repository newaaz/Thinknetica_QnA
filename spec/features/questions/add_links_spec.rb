require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As the author of the question
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:link_url) { 'https://preview.tabler.io/form-elements.html' }  

  background { sign_in user  }
  
  describe 'User add links when create question' do

    background do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question body'
    end

    scenario 'with valid link', js: true do  
      click_on 'add link'    
    
      page.all('.nested-fields').each do |field|
        within(field) do
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: link_url
        end
      end   
      
      click_on 'Ask'
    
      expect(page).to have_link 'My gist', href: link_url, count: 2
    end

    scenario 'with invalid' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'wrong url'
      
      click_on 'Ask'

      expect(page).to have_content "Invalid url"
    end

    scenario 'with links to non-existent page' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'https://wrongsite/wrongsite/78edbf7ec647d87cacd1bffa2a51b3ad'
      
      click_on 'Ask'

      expect(page).to have_content "This page does not exist"
    end
  end

  describe 'User add links wnen edit question' do
    given!(:question) { create(:question, author: user) }
  
    scenario 'User add links when edit question', js: true do 
      visit question_path question       
      
      within '.question' do
        click_on 'Edit question'
        click_on 'add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: link_url
        click_on 'Save changes'
    
        expect(page).to have_link 'My gist', href: link_url
      end
    end
  end
end

