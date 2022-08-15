require 'rails_helper'

feature 'User can answer the question', %q{
  In order to help with problem
  As an authenticated user
  I'd like to be able to create answer on question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path question
    end

    scenario 'answers the question' do      
      fill_in 'Body', with: 'Correct answer - you need update gem'
      click_on 'Add answer'
  
      expect(current_path).to eq question_path question
      within '.answers' do
        expect(page).to have_content 'Correct answer - you need update gem'
      end      
    end
  
    scenario 'answers the question with errors' do
      click_on 'Add answer'
      expect(page).to have_content 'error(s) detected:'
    end

    scenario 'create answer with attached files' do
      within '.answer-form' do
        fill_in 'Body', with: 'Correct answer - you need update gem'          
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Add answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user answers the question' do
    visit question_path question
    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
