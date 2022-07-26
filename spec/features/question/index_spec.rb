require 'rails_helper'

feature 'User can view the list of all questions', %q{
  In order to view list of all questions
  As an any user
  I'd like to be able to view the list of all questions
} do

  given!(:questions) { create_list(:question, 3) }
  given!(:user) { create(:user) }

  scenario 'Authenticated user view list of all questions' do
    sign_in(user)
    check_all_questions
  end

  scenario 'Unauthenticated user view list of all questions' do  
    check_all_questions  
  end

  def check_all_questions
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end    
  end
end
