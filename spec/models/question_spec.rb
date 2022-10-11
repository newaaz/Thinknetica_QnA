require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }  
    it { should have_one(:award).dependent(:destroy) }
    it { should have_and_belong_to_many(:subscribers).class_name('User') }

    it { should accept_nested_attributes_for :award }

    it_behaves_like 'Authorable'
    it_behaves_like 'Linkable'
    it_behaves_like 'Votable'
    it_behaves_like 'Commentable'
    it_behaves_like 'Attachmentable'
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'reputation' do
    let(:question)  { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
