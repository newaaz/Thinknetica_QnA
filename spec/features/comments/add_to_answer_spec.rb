require 'rails_helper'

feature 'User can to leave comment to the answer', %q{
  In order to help with problem
  As an authenticated user
  I'd like to be able to create comment on answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question) }

  describe 'multiple_sessions', js: true do
    scenario "new comment appears on author's page and on another user's page" do
      Capybara.using_session('user') do
        sign_in user
        visit question_path question         
      end
      
      Capybara.using_session('quest') do
        visit question_path question      
      end

      Capybara.using_session('user') do
        within "#answer_#{answer.id}" do
          click_on 'New comment'
          fill_in 'Body', with: 'Nice answer!!!'
          click_on 'Add comment'
  
          expect(page).to have_content 'Nice answer!!!', count: 1
        end               
      end

      Capybara.using_session('quest') do
        within "#answer_#{answer.id}" do
          expect(page).to have_content 'Nice answer!!!', count: 1
        end
      end
    end

    scenario "new comment with errors" do
      Capybara.using_session('user') do
        sign_in user
        visit question_path question         
      end
      
      Capybara.using_session('quest') do
        visit question_path question      
      end

      Capybara.using_session('user') do
        within "#answer_#{answer.id}" do
          click_on 'New comment'
          click_on 'Add comment'
  
          expect(page).to have_content "can't be blank"
        end               
      end

      Capybara.using_session('quest') do
        within "#answer_#{answer.id}" do
          expect(page).to_not have_content 'Nice answer!!!'
        end
      end
    end
  end

  scenario 'Unauthenticated user want add comment to the answer' do
    visit question_path question
    within "#answer_#{answer.id}" do
      expect(page).to_not have_link 'New comment'
    end
  end
end
