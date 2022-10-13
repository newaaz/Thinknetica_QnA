require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:author)    { create(:user) }
  let(:user)      { create(:user) }
  let(:question)  { create(:question, author: author) }
  let(:answer)    { create(:answer, question: question, author: user) }  

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }
    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new Link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(author) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link for question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(author) }

    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(author) }

    context 'with valid attributes' do
      it 'saves a new question in the DB' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'add subscribe to question' do
        post :create, params: { question: attributes_for(:question) }
        expect(author.subscribed_questions.count).to eq 1
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question in the DB' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(author) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        old_title = question.title
        question.reload

        expect(question.title).to eq old_title
        expect(question.body).to eq 'MyText'
      end

      it 'render update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid author' do
      before { login(user) }
      
      it 'not changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'PATCH #set_best_answer' do
    context 'Author of best answer get award' do
      let(:question)  { create(:question, author: author, award: create(:award)) }
      let(:answer)    { create(:answer, question: question, author: user) }

      it 'assign award user to best answer author' do
        login author
        patch :set_best_answer, params: { id: question, best_answer_id: answer.id }, format: :js
        question.reload

        expect(question.award.user).to eq user
      end
    end

    context 'sets best answer to their question (valid author)' do  
      it 'set best answer for question' do 
        login author
        patch :set_best_answer, params: { id: question, best_answer_id: answer.id }, format: :js
        question.reload 
        expect(question.best_answer).to eq answer  
      end
    end

    context 'sets best answer to other user question (invalid author)' do
      it 'do not set best answer for question' do
        login user
        patch :set_best_answer, params: { id: question, best_answer_id: answer.id }, format: :js
        question.reload
        expect(question.best_answer).to_not eq answer  
      end
    end

    context 'Unauthenticated user tries sets best answer to question (invalid author)' do
      it 'do not set best answer for question' do
        patch :set_best_answer, params: { id: question, best_answer_id: answer.id }, format: :js
        question.reload
        expect(question.best_answer).to_not eq answer  
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'valid author' do
      before { login(author) }
      let!(:question) { create(:question, author: author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
  
      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end      
    end
    
    context 'invalid author' do
      before { login(user) }    
      let!(:question) { create(:question, author: author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
