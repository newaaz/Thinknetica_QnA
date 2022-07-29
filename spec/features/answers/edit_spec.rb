require 'rails_helper'

feature 'User can edit his answer', %q{
    In order to correct mistakes
    As an author of answer
    I'd like to be able to edit my answer
} do
  
  given!(:user)     { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question, author: user) }

  scenario 'Unauthentivated user can not edit answer' do
    visit question_path question

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user', js: true do
  
    scenario 'edit his answer' do
      sign_in user
      visit question_path question

      # save_and_open_page
      click_on 'Edit answer'
      
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Update answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors'

    scenario 'tries to edit othe user answer'
  
  end

end
