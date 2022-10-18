require 'sphinx_helper'

feature 'User can search in resources by keywords', %q{
  In order to find need information
  As any user
  I'd like to be able search for resources containing keywords
} do

  given(:user)      { create(:user) }
  given(:question)  { create(:question, author: user, title: 'question for foobar') }
  given(:answer)    { create(:answer, question: question, body: 'answer for foobar') }
  given!(:comment)  { create(:comment, commentable: answer, body: 'comment for foobar') }

  scenario 'search info in all resources', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('.search-form') do
        fill_in 'search_query', with: 'foobar'
        click_on 'Search'
      end
      
      expect(page).to have_content 'answer for foobar'
      expect(page).to have_content 'comment for foobar'
      expect(page).to have_content 'question for foobar'
    end  
  end

  scenario 'search info in one resource', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('.search-form') do
        fill_in 'search_query', with: 'foobar'
        page.select('Question', from: 'resources')
        click_on 'Search'
      end
      
      expect(page).to_not have_content 'answer for foobar'
      expect(page).to_not have_content 'comment for foobar'
      expect(page).to have_content 'question for foobar'
    end  
  end

  scenario 'search info in multiple resources', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('.search-form') do
        fill_in 'search_query', with: 'foobar'
        page.select('Question', from: 'resources')
        page.select('Answer', from: 'resources')
        click_on 'Search'
      end
      
      expect(page).to have_content 'answer for foobar'
      expect(page).to_not have_content 'comment for foobar'
      expect(page).to have_content 'question for foobar'
    end  
  end

  scenario 'search with empty query', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('.search-form') do
        click_on 'Search'
      end
      
      expect(page).to have_content 'Type something in search field' 
    end  
  end
  
  scenario 'search with not found result', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within('.search-form') do
        fill_in 'search_query', with: 'foo'
        click_on 'Search'
      end
      
      expect(page).to have_content 'Nothing found for your request' 
    end  
  end
end
