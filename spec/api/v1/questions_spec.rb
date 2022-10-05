require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path)  { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method)  { :get }
    end
    
    context 'authorized' do
      let(:access_token)      { create(:access_token) }
      let!(:questions)        { create_list(:question, 3) }
      let(:question)          { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers)          { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API success response'

      it_behaves_like 'API list of resources' do
        let(:resources)  { json['questions'] }
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end 
      end

      describe 'answers' do
        let(:answer)          { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'contain short title' do
          expect(question_response['short_title']).to eq question.title.truncate(5)
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end 
        end        
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:resource)          { create(:question) }    
    let!(:links)            { create_list(:link, 3, :for_question, linkable: resource) }
    let(:comments)          { create_list(:comment, 3, :for_question, commentable: resource) }
    let!(:comment)          { comments.first }
    let(:resource_response) { json['question'] }
    let(:api_path)          { "/api/v1/questions/#{resource.id}" }

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

  describe 'POST /api/v1/questions' do
    let(:method)    { :post }
    let(:api_path)  { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me)                { create(:user) }
      let(:access_token)      { create(:access_token, resource_owner_id: me.id) }
      let(:question_response) { json['question'] }

      context 'with valid attributes' do
        let(:send_request)  { post api_path, params: { question: attributes_for(:question), access_token: access_token.token }, headers: headers }

        it 'saves a new question in the DB' do
          expect { send_request }.to change(Question, :count).by(1)
        end

        it 'returns correct question json' do
          send_request
          expect(question_response['title']).to match(/(^Title of question )/)
        end
        
        it 'correct author of question' do
          send_request
          expect(Question.last).to eq me.authored_questions.last
        end
      end

      context 'with invalid attributes' do
        let(:send_invalid_request)  { post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }, headers: headers }

        it 'does not save a new question in the DB' do
          expect { send_invalid_request }.to_not change(Question, :count)
        end

        it_behaves_like 'API return errors on create/update'
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:author)        { create(:user) }
    let!(:question)     { create(:question, author: author) }   
    let(:method)        { :patch }
    let(:api_path)      { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:access_token)  { create(:access_token, resource_owner_id: author.id) }
        let(:send_request)  { patch api_path, params: { id: question.id, question: { title: 'new title', body: 'new body' }, access_token: access_token.token }, headers: headers }

        before { send_request }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          question.reload
  
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render question json' do
          expect(json['question']['title']).to eq 'new title'
        end
      end

      context 'with invalid attributes' do
        let(:access_token)          { create(:access_token, resource_owner_id: author.id) }
        let(:send_invalid_request)  { patch api_path, params: { id: question.id, question: { title: '', body: '' }, access_token: access_token.token }, headers: headers }

        before { send_invalid_request }

        it 'does not change question' do
          old_title = question.title
          question.reload
  
          expect(question.title).to eq old_title
          expect(question.body).to eq 'MyText'
        end

        it_behaves_like 'API return errors on create/update'
      end

      context 'non author of question' do
        let(:non_author)    { create(:user) }
        let(:access_token)  { create(:access_token, resource_owner_id: non_author.id) }
        let(:send_request)  { patch api_path, params: { id: question.id, question: { title: 'new title', body: 'new body' }, access_token: access_token.token }, headers: headers }

        it 'not changes question attributes' do
          question.reload
  
          expect(question.title).to_not eq 'new title'
          expect(question.body).to_not eq 'new body'
        end

        it_behaves_like 'API status redirect'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do 
    let(:author)        { create(:user) }
    let!(:question)     { create(:question, author: author) }   
    let(:method)        { :delete }
    let(:api_path)      { "/api/v1/questions/#{question.id}" }
    let(:send_request)  { delete api_path, params: { id: question.id, access_token: access_token.token }, headers: headers }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API deletable' do
      let(:resource)  { question }
    end
  end
end
 