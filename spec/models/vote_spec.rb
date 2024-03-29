require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to(:votable) }
    it { should belong_to(:user) }
  end
end
