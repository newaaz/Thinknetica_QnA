require 'rails_helper'

feature 'Author can delete links belongs his question', %q{
    In order to correct mistakes
    As an author of question
    I'd like to be able to delete links belongs to my question
} do

  given(:author)    { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:link)      { create(:link, :for_question, linkable: question) }

  scenario 'Author delete link when edit question', js: true do
    sign_in author      
    visit question_path question

    click_on 'Edit question'

    find("#link_#{link.id}").click_on 'delete'

    expect(page).to_not have_content 'Link for question'
  end


end

