require 'rails_helper'

feature 'Authenticated user can vote for the answer they liked', %q{
  In order to like or dislike answer
  As authenticated user and not author of answer
  I'd like to be able to vote for the answer
} do

  given(:author)    { create(:user) }
  given(:user)      { create(:user) }
  given(:question)  { create(:question, author: author) }
  given!(:answer)   { create(:answer, question: question, author: author) }

  describe 'Authenticated user and not author of answer', js: true do
    background do
      sign_in(user) 
      visit question_path(question)   
    end

    scenario 'vote up per answer' do
      within "#vouting_answer_#{answer.id}" do
        click_on 'Like'
  
        within '.rating' do
          expect(page).to have_content "1"
        end

        expect(page).to have_link('Like', class: 'enabled')
        expect(page).to_not have_link('Dislike', class: 'enabled')      
      end
    end

    scenario 'vote up twice per answer (cancel vote)' do
      within "#vouting_answer_#{answer.id}" do
        click_on 'Like'
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content "0"
        end

        expect(page).to_not have_link('Like', class: 'enabled')
      end
    end

    scenario 'vote down per answer' do
      within "#vouting_answer_#{answer.id}" do
        click_on 'Dislike'
  
        within '.rating' do
          expect(page).to have_content "-1"
        end

        expect(page).to_not have_link('Like', class: 'enabled')
        expect(page).to have_link('Dislike', class: 'enabled')      
      end
    end

    scenario 'vote down twice per answer (cancel vote)' do
      within "#vouting_answer_#{answer.id}" do
        click_on 'Dislike'
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content "0"
        end

        expect(page).to_not have_link('Dislike', class: 'enabled')
      end
    end

    scenario 'vote up, then down (change vote)' do
      within "#vouting_answer_#{answer.id}" do
        click_on 'Like'
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content "-1"
        end

        expect(page).to have_link('Dislike', class: 'enabled')
        expect(page).to_not have_link('Like', class: 'enabled')
      end
    end

    scenario 'vote down, then up (change vote)' do
      within "#vouting_answer_#{answer.id}" do
        click_on 'Dislike'
        click_on 'Like'        

        within '.rating' do
          expect(page).to have_content "1"
        end

        expect(page).to_not have_link('Dislike', class: 'enabled')
        expect(page).to have_link('Like', class: 'enabled')
      end
    end
  end

  scenario 'Author of answer vote for their answer', js: true do
    sign_in author
    visit question_path(question) 

    within "#vouting_answer_#{answer.id}" do
      click_on 'Like'        

      within '.rating' do
        expect(page).to have_content "0"
      end
      
      expect(page).to have_content('You are the author of this question')
    end
  end

  scenario 'Unauthenticated user vote for answer' do
    visit question_path(question)

    within "#vouting_answer_#{answer.id}" do
      expect(page).to_not have_link('Like')
      expect(page).to_not have_link('Dislike')
    end
  end
end
