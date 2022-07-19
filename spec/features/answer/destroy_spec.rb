require 'rails_helper'

feature 'Only author can delete his answer', %q{
  In order to other users can't delete my answers
  As an authenticated user
  I'd like to be able to delete only my answer
} do

  scenario 'Authenticated user tries to delete his answer'

  scenario "Authenticated user tries to delete someone else's question answer"

  scenario 'Unauthenticated user tries to delete his answer'

end


