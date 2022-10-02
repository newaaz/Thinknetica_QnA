require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

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

      it_behaves_like 'API resource attachments'

      it_behaves_like 'API resource links'
  
      it_behaves_like 'API resource comments'
    end
  end
end
 
