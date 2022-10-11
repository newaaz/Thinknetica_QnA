require 'rails_helper'

feature 'Authentcated user can subscribe to a question', %q{
  In order to be notified of new answers to a question
  As an authenticated user
  I'd like to be able to subscribe to a question
} do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authentcated user' do
    background { sign_in user }

    scenario 'subscribe on question' do
      visit question_path question
      click_on 'Subscribe'
      expect(page).to have_content 'You subscribed to this question'
      expect(page).to have_button 'Unsubscribe'
    end

    scenario 'Already subscribed to this question' do
      user.subscribed_questions << question
      visit question_path question
      expect(page).to have_content 'You subscribed to this question'

      click_on 'Unsubscribe'
      expect(page).to have_button 'Subscribe'
      expect(page).to have_content 'You unsubscribed from this question'
    end    
  end
end
