require 'rails_helper'

feature 'User can edit his question', %q{
    In order to correct mistakes
    As an author of question
    I'd like to be able to edit my question
} do

  given(:author)   { create(:user) }
  given(:user)   { create(:user) }
  given!(:question) { create(:question, author: author) }

  describe 'Authenticated user', js: true do
    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'old_attachment.rb')

      sign_in author      
      visit question_path question
      click_on 'Edit question'
    end
  
    scenario 'edit his question' do
      within '.question' do
        fill_in 'question_title', with: 'edited question title'
        fill_in 'question_body', with: 'edited question body'

        click_on 'Save changes'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question title'
        expect(page).to_not have_selector 'form'
      end
    end

    scenario 'edit his question with errors' do
      within '.question' do
        fill_in 'question_title', with: ''
        fill_in 'question_body', with: ''

        click_on 'Save changes'

        expect(page).to have_content 'error(s) detected'
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'form'
      end
    end

    scenario 'adds files when question editing' do
      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save changes'

        expect(page).to have_content 'old_attachment.rb'
        expect(page).to have_content 'spec_helper.rb'
        expect(page).to have_content 'rails_helper.rb'
      end
    end

    scenario 'delete attachments files when question editing' do
      within '.question' do
        click_on 'delete this file'

        expect(page).to_not have_content 'old_attachment.rb'
      end
    end
  end

  scenario 'Authenticated user tries to edit other user question' do
    sign_in user
    visit question_path question

    expect(page).to_not have_link "Edit question"
  end

  scenario 'Unauthentivated user can not edit question' do
    visit question_path question

    expect(page).to_not have_link "Edit question"
  end
end
