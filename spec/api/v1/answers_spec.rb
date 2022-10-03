require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT TYPE" => "application/json" } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question)          { create(:question) }
    let(:answers)           { create_list(:answer, 3, question_id: question.id) }
    let!(:answer)           { answers.first }
    let(:answer_response)   { json['answers'].first }
    let(:api_path)          { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method)  { :get }
    end
    
    context 'authorized' do
      let(:access_token)      { create(:access_token) }      

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API list of resources' do
        let(:resources)  { json['answers'] }
      end

      it 'return correct answer' do
        expect(answer_response['id']).to eq answer.id
      end
    end  
  end

  describe 'GET /api/v1/answers/:id' do
    let(:resource)          { create(:answer) }
    let!(:links)            { create_list(:link, 3, :for_answer, linkable: resource) }
    let(:comments)          { create_list(:comment, 3, :for_answer, commentable: resource) }
    let!(:comment)          { comments.first }
    let(:resource_response) { json['answer'] }
    let(:api_path)          { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method)  { :get }
    end

    context 'authorized' do
      let(:access_token)      { create(:access_token) }      
  
      before do
        resource.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'first_attachment.rb')
        resource.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'second_attachment.rb')
  
        get api_path, params: { access_token: access_token.token }, headers: headers
      end
  
      it_behaves_like 'API success response'

      it_behaves_like 'API resource attachmentable'

      it_behaves_like 'API resource linkable'
  
      it_behaves_like 'API resource commentable'
    end
  end

  describe 'POST /api/v1/questions/question_id/answers' do
    let(:question)  { create(:question) }
    let(:method)    { :post }
    let(:api_path)  { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me)                { create(:user) }
      let(:access_token)      { create(:access_token, resource_owner_id: me.id) }
      let(:answer_response)   { json['answer'] }

      context 'with valid attributes' do
        let(:send_request)  { post api_path, params: { answer: attributes_for(:answer), question_id: question.id, access_token: access_token.token }, headers: headers }

        it 'saves a new question in the DB' do
          expect { send_request }.to change(Answer, :count).by(1)
        end

        it 'returns correct answer json' do
          send_request
          expect(answer_response['body']).to eq 'Correct answer - you need update gem'
        end
        
        it 'correct author of question' do
          send_request
          expect(Answer.last).to eq me.authored_answers.last
        end
      end

      context 'with invalid attributes' do
        let(:send_invalid_request)  { post api_path, params: { answer: attributes_for(:answer, :invalid), question_id: question.id, access_token: access_token.token }, headers: headers }
        
        it 'does not save a new question in the DB' do
          expect { send_invalid_request }.to_not change(Answer, :count)
        end

        it_behaves_like 'API return errors on create/update'
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:author)        { create(:user) }
    let!(:answer)       { create(:answer, author: author) }   
    let(:method)        { :patch }
    let(:api_path)      { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:access_token)  { create(:access_token, resource_owner_id: author.id) }
        let(:send_request)  { patch api_path, params: { id: answer.id, answer: { body: 'new body' }, access_token: access_token.token }, headers: headers }

        before { send_request }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          answer.reload
  
          expect(answer.body).to eq 'new body'
        end

        it 'render answer json' do
          expect(json['answer']['body']).to eq 'new body'
        end
      end

      context 'with invalid attributes' do
        let(:access_token)          { create(:access_token, resource_owner_id: author.id) }
        let(:send_invalid_request)  { patch api_path, params: { id: answer.id, answer: { body: '' }, access_token: access_token.token }, headers: headers }

        before { send_invalid_request }

        it 'does not change answer' do
          old_body = answer.body
          answer.reload
  
          expect(answer.body).to eq 'Correct answer - you need update gem'
        end

        it_behaves_like 'API return errors on create/update'
      end

      context 'non author of answer' do
        let(:non_author)    { create(:user) }
        let(:access_token)  { create(:access_token, resource_owner_id: non_author.id) }
        let(:send_request)  { patch api_path, params: { id: answer.id, answer: { body: 'new body' }, access_token: access_token.token }, headers: headers }

        it 'not changes answer attributes' do
          answer.reload
  
          expect(answer.body).to_not eq 'new body'
        end

        it_behaves_like 'API status redirect'
      end
    end
    
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:author)        { create(:user) }
    let!(:answer)       { create(:answer, author_id: author.id) }
    let(:method)        { :delete }
    let(:api_path)      { "/api/v1/answers/#{answer.id}" }
    let(:send_request)  { delete api_path, params: { id: answer.id, access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API deletable' do
      let(:resource)  { answer }
    end
  end
end
 
