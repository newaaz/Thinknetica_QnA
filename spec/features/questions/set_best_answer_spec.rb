require 'rails_helper'

feature 'Only author can set best answer on their question', %q{
  In order to other users can see what answer helped solve the problem
  As an authenticated user and author of question
  I'd like to be able to set best answer to my question
} do

  given!(:author)       { create(:user) }
  given!(:question)     { create(:question, author: author) }
  given!(:answer)       { create(:answer, author: author, question: question) }
  given!(:other_answer) { create(:answer, body: "second answer",author: author, question: question) }
  given!(:user)         { create(:user) }

  describe 'Question author' , js: true do
    background do
      sign_in author
      visit question_path question

      within "#answer_#{answer.id}" do
        click_on 'Mark the best'
      end      
    end

    scenario 'mark answer as the to their question' do
      within '.best-answer' do
        expect(page).to have_content answer.body
      end

      within '.answers' do
        expect(page).to_not have_content answer.body
      end
    end

    scenario 'mark other answer as the best' do
      within "#answer_#{other_answer.id}" do
        click_on 'Mark the best'
      end

      within '.best-answer' do
        expect(page).to have_content other_answer.body
      end

      within '.answers' do
        expect(page).to_not have_content other_answer.body
        expect(page).to have_content answer.body
      end
    end
  end

  scenario 'Authenticated user tries mark best answer on other user question' do
    sign_in user
    visit question_path question

    within "#answer_#{answer.id}" do
      expect(page).to_not have_content 'Mark the best'
    end 
  end

  scenario 'Unauthenticated user tries mark best answer' do
    visit question_path question

    within "#answer_#{answer.id}" do
      expect(page).to_not have_content 'Mark the best'
    end 
  end
end
