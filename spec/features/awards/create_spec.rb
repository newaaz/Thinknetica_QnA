require 'rails_helper'

feature 'Author of question can an award for the best answer', %q{
  In order to award for the best answer
  As the author of the question
  I'd like to be able to create award for best answer on my question
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Question Title'
    fill_in 'Body', with: 'Question body'
  end

  scenario 'create question with award' do  
    fill_in 'Award`s title', with: 'For the mind'
    attach_file 'Image', "#{Rails.root}/app/assets/images/icons/award.png" 
        
    click_on 'Ask'

    expect(page).to have_content 'For the mind'
  end

  scenario 'create question with award with errors' do  
    attach_file 'Image', "#{Rails.root}/app/assets/images/icons/award.png" 
        
    click_on 'Ask'

    expect(page).to have_content "Award title can't be blank"
  end

  scenario 'create question with award with invalid type of attachment' do  
    fill_in 'Award`s title', with: 'For the mind'
    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb" 
        
    click_on 'Ask'

    expect(page).to have_content "Uploaded file must be image"
  end

  scenario 'create question with award with  image more tnan max size of attachment' do  
    fill_in 'Award`s title', with: 'For the mind'
    attach_file 'Image', "#{Rails.root}/storage/large.jpg" 
        
    click_on 'Ask'

    expect(page).to have_content "Uploaded file must be less"
  end

end


