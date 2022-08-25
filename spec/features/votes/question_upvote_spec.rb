require 'rails_helper'

feature 'Authenticated user can vote for the question they liked', %q{
  In order to see the best questions
  As authenticated user
  I'd like to be able to vote for the question
} do

  given(:user)      { create(:user) }
  given!(:question)  { create(:question) }

  background do
    sign_in(user) 
    visit root_path   
  end

  scenario 'Create a question' do
    

    within "#question_#{question.id}" do
      click_on 'Like'

      within '.question-rating' do
        expect(page).to have_content "1"
      end
    end




  end

=begin
  describe 'Authenticated user' do
    background do    
    end
  
    scenario 'Create a question' do      
    end   
  end
=end

end


