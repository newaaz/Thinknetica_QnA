require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, author: author) }

  describe 'POST #create' do
    before { login(author) }

    context 'with valid attributes' do
      it 'saves a new answer in the DB' do
        expect  { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }
                .to change(Answer, :count).by(1)
      end

      it 'answer belongs to right question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(assigns(:answer).question).to eq question
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not saves answer in the DB' do
        expect  { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }
                .to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(author) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: "new edited answer" } }, format: :js
        answer.reload
        expect(answer.body).to eq "new edited answer"
      end

      it 'render update template' do
        patch :update, params: { id: answer, answer: { body: "new edited answer" } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'render update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end    
    end

    context 'with invalid author' do
      before { login(user) }

      it 'not changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: "new edited answer" } }, format: :js
        answer.reload
        expect(answer.body).to_not eq "new edited answer"
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'valid author' do
      before { login(author) } 

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'invalid author' do
      before { login(user) } 

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end

    context 'Unauthenticated user' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end
end
