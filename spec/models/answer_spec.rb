require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }

    it_behaves_like 'Authorable'
    it_behaves_like 'Linkable'
    it_behaves_like 'Votable'
    it_behaves_like 'Commentable'
    it_behaves_like 'Attachmentable'
  end

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
  end

  describe 'notification' do
    let(:question)  { create(:question) }
    let(:answer)    { build(:answer, question: question) }

    it 'call NewAnswerNotifyJob' do
      expect(NewAnswerNotifyJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end
end
