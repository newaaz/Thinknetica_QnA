require 'rails_helper'

feature 'User can to leave comment to the question', %q{
  In order to help with problem
  As an authenticated user
  I'd like to be able to create comment on question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

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
        click_on 'New comment'

        within "#question_#{question.id}" do
          fill_in 'Body', with: 'Nice question!!!'
          click_on 'Add comment'
  
          expect(page).to have_content 'Nice question!!!', count: 1
        end               
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'Nice question!!!', count: 1
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
        click_on 'New comment'

        within "#question_#{question.id}" do
          click_on 'Add comment'          
        end
        
        expect(page).to have_content "can't be blank"
      end

      Capybara.using_session('quest') do
        expect(page).to_not have_content 'Nice question!!!'
      end
    end
  end

  scenario 'Unauthenticated user want add comment to the question' do
    visit question_path question
    expect(page).to_not have_link 'New comment'
  end
end
