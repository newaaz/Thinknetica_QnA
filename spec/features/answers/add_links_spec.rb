require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question
  As anquestion's author
  I'd like to be able to add links
} do

  given(:user)      { create(:user) }
  given(:question)  { create(:question) }
  given!(:answer)   { create(:answer, question: question, author: user) } 
  given(:link_url)  { 'https://preview.tabler.io/form-elements.html' }

  background do
    sign_in(user)
    visit question_path question    
  end

  describe 'User add links when create answer', js: true do
    background { find('.answer-form').fill_in 'Body', with: 'Correct answer - you need update gem' }

    scenario 'with valid url' do    
      within '.answer-form' do 
        click_on 'add link'      
  
        page.all('.nested-fields').each do |field|
          within(field) do
            fill_in 'Link name', with: 'My gist'
            fill_in 'Url', with: link_url
          end
        end  
    
        click_on 'Add answer'
      end     
      
      within '.answers' do
        expect(page).to have_link 'My gist', href: link_url, count: 2
      end
    end
  
    scenario 'with invalid url' do
      within '.answer-form' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: 'wrong url'
        
        click_on 'Add answer'
  
        expect(page).to have_content "Invalid url"
      end
    end
  
    scenario 'with link to non-existent page' do
      within '.answer-form' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: 'https://wrongsite/wrongsite/78edbf7ec647d87cacd1bffa2a51b3ad'
  
        click_on 'Add answer'
        sleep 0.5
        expect(page).to have_content "This page does not exist"
      end
    end    
  end

  describe 'User add links when edit answer', js: true do
    

    scenario 'with valid url' do
      within "#answer_#{answer.id}" do
        click_on 'Edit answer'

        click_on 'add link' 

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: link_url

        click_on 'Update answer'

        expect(page).to have_link 'My gist', href: link_url
      end
    end

  end

end

