require 'rails_helper'

feature 'User can edit his answer', %q{
    In order to correct mistakes
    As an author of answer
    I'd like to be able to edit my answer
} do
  
  given(:author)   { create(:user) }
  given(:user)   { create(:user) }
  given(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question, author: author) }

  describe 'Authenticated user', js: true do
    background do
      sign_in author
      visit question_path question

      click_on 'Edit answer'
    end
  
    scenario 'edit his answer' do      
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Update answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do      
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Update answer'

        expect(page).to have_content 'error(s) detected'
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end
  end

  scenario 'Authenticated user tries to edit other user answer' do
    sign_in user
    visit question_path question

    expect(page).to_not have_link 'Edit answer'
  end 

  scenario 'Unauthentivated user can not edit answer' do
    visit question_path question

    expect(page).to_not have_link 'Edit answer'
  end
end
