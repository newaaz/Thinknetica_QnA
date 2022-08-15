require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
  #  it { should has_many(:award).dependent(:destroy) }   
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end
end
