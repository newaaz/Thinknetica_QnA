require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user)      { create(:user) }
  let(:question)  { create(:question) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login user }

      it 'saves a new subscription' do        
        expect { post :create, params: { question_id: question.id } }.to change(Subscription, :count).by(1)
      end

      it 'add question to subscribes' do
        post :create, params: { question_id: question.id }
        expect(user.subscribed_questions.last).to eq question
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      before do
        question.subscribers << user
        login user
      end

      it 'delete the subscription' do
        expect { delete :destroy, params: { id: question.id } }.to change(Subscription, :count).by(-1)
      end

      it 'user does not subscribe to the question' do
        delete :destroy, params: { id: question.id }
        expect(user.subscribed_on?(question)).to eq false
      end
    end  
  end
end
