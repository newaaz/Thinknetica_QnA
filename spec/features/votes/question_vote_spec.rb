require 'rails_helper'

feature 'Authenticated user can vote for the question they liked', %q{
  In order to like or dislike question 
  As authenticated user and not author of question
  I'd like to be able to vote for the question
} do

  given(:author)      { create(:user) }
  given(:user)      { create(:user) }
  given!(:question)  { create(:question, author: author) }

  describe 'Authenticated user and not author of question', js: true do
    background do
      sign_in(user) 
      visit root_path   
    end

    scenario 'vote up per question' do
      within "#vouting_question_#{question.id}" do
        click_on 'Like'
  
        within '.question-rating' do
          expect(page).to have_content "1"
        end

        expect(page).to have_link('Like', class: 'enabled')
        expect(page).to_not have_link('Dislike', class: 'enabled')      
      end
    end

    scenario 'vote up twice per question (cancel vote)' do
      within "#vouting_question_#{question.id}" do
        click_on 'Like'
        click_on 'Like'

        within '.question-rating' do
          expect(page).to have_content "0"
        end

        expect(page).to_not have_link('Like', class: 'enabled')
      end
    end

    scenario 'vote down per question' do
      within "#vouting_question_#{question.id}" do
        click_on 'Dislike'
  
        within '.question-rating' do
          expect(page).to have_content "-1"
        end

        expect(page).to_not have_link('Like', class: 'enabled')
        expect(page).to have_link('Dislike', class: 'enabled')      
      end
    end

    scenario 'vote down twice per question (cancel vote)' do
      within "#vouting_question_#{question.id}" do
        click_on 'Dislike'
        click_on 'Dislike'

        within '.question-rating' do
          expect(page).to have_content "0"
        end

        expect(page).to_not have_link('Dislike', class: 'enabled')
      end
    end

    scenario 'vote up, then down (change vote)' do
      within "#vouting_question_#{question.id}" do
        click_on 'Like'
        click_on 'Dislike'

        within '.question-rating' do
          expect(page).to have_content "-1"
        end

        expect(page).to_not have_link('Like', class: 'enabled')
        expect(page).to have_link('Dislike', class: 'enabled')
      end
    end

    scenario 'vote down, then up (change vote)' do
      within "#vouting_question_#{question.id}" do
        click_on 'Dislike'
        click_on 'Like'

        within '.question-rating' do
          expect(page).to have_content "1"
        end

        expect(page).to have_link('Like', class: 'enabled')
        expect(page).to_not have_link('Dislike', class: 'enabled')
      end
    end
  end

  scenario 'Author of question vote for this question', js: true do
    sign_in(author)
    visit root_path

    within "#vouting_question_#{question.id}" do
      click_on 'Like'

      within '.question-rating' do
        expect(page).to have_content "0"
      end

      expect(page).to have_content('You are the author of this question')
    end
  end
end


