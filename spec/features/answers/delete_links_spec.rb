require 'rails_helper'

feature 'Author can delete links belongs his answer', %q{
    In order to correct mistakes
    As an author of answer
    I'd like to be able to delete links belongs to my answer
} do

  given(:author)    { create(:user) }
  given(:question)  { create(:question, author: author) }
  given(:answer)    { create(:answer, author: author, question: question) }
  given!(:link)     { create(:link, :for_question, linkable: answer) }

  scenario 'Author delete link when edit question', js: true do
    sign_in author      
    visit question_path question

    click_on 'Edit answer'

    find("#link_#{link.id}").click_on 'delete'

    expect(page).to_not have_content 'Link for answer'
  
  end

end

