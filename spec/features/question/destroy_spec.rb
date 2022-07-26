require 'rails_helper'

feature 'Only author can delete his question', %q{
  In order to other users can't delete my questions
  As an authenticated user
  I'd like to be able to delete only my question
} do

  given(:author)    { create(:user) }
  given(:question)  { create(:question, author: author) }   
  given(:user)      { create(:user) }

  scenario 'Authenticated user tries to delete his question' do
    sign_in(author)

    visit question_path question
    click_on 'Delete this question'

    expect(page).to have_content 'Your question was deleted'
    expect(page).to_not have_content question.title
  end

  scenario "Authenticated user tries to delete someone else's question" do
    sign_in(user)
    visit question_path question

    expect(page).to_not have_content 'Delete this question'      
  end
  

  scenario 'Unauthecnticated user tries to delete question' do
    visit question_path question

    expect(page).to_not have_content 'Delete this question' 
  end
end
