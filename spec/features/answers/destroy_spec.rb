require 'rails_helper'

feature 'Only author can delete his answer', %q{
  In order to other users can't delete my answers
  As an authenticated user
  I'd like to be able to delete only my answer
} do

  given!(:author)    { create(:user) }
  given!(:question)  { create(:question, author: author) }
  given!(:answer)    { create(:answer, author: author, question: question) }
  given!(:user)      { create(:user) }

  scenario 'Authenticated user tries to delete his answer' do
    sign_in(author)
    visit question_path question
    click_on 'Delete answer'

    expect(page).to have_content 'Answer was deleted'
    expect(page).to_not have_content answer.body
  end

  scenario "Authenticated user tries to delete someone else's question answer" do
    sign_in(user)
    visit question_path question

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Unauthenticated user tries to delete his answer' do
    visit question_path question

    expect(page).to_not have_content 'Delete answer'
  end
end
