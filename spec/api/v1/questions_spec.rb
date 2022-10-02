require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

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

      it_behaves_like 'API resource attachments'

      it_behaves_like 'API resource links'
  
      it_behaves_like 'API resource comments'  
    end
  end
end
 