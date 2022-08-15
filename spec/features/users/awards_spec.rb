require 'rails_helper'

feature 'User can see their rewards', %q{
  In order to award for the best answer
  As the author of the question
  I'd like to be able to create award for best answer on my question
} do

  given(:user)        { create(:user) }
  given(:questions)   { create_list(:question, 2) }
  given!(:award1)     { create(:award, question: questions[0], user: user) }
  given!(:award2)     { create(:award, question: questions[1], user: user) }

  scenario 'create question with award' do
    sign_in user    
    click_on 'Awards'

    expect(page).to have_content "Award title", count: 2
    expect(page).to have_css('img'), count: 2
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title    
  end
end
