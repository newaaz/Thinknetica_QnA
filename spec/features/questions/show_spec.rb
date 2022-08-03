require 'rails_helper'

feature 'User can view question and answers to it', %q{
  In order to get help with problem
  Any User
  I'd like to be able to view question and answers to it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Authenticated user view question and answers to it' do
    sign_in(user)
    check_question_with_answers
  end

  scenario 'Unauthenticated user view question and answers to it' do
    check_question_with_answers
  end

  def check_question_with_answers
    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content("Correct answer - you need update gem", count: 3)
  end
end
