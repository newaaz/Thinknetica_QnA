require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) { { "CONTENT TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method)    { :get }
      let(:api_path)  { '/api/v1/profiles/me' }
    end
     
    context 'authorized' do
      let(:me)            { create(:user) }
      let(:access_token)  { create(:access_token, resource_owner_id: me.id) }
      let(:user_response) { json['user'] }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API success response'

      it_behaves_like 'API private fields'

      it_behaves_like 'API public fields' do
        let(:user)  { me }
      end

    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path)      { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method)    { :get }      
    end

    context 'authorized' do
      let(:users)         { create_list(:user, 3) }
      let(:owner)         { users.first }
      let(:access_token)  { create(:access_token, resource_owner_id: owner.id) }
      let(:user_response) { json['users'][0] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API success response'

      it 'returns list of users without one' do
        expect(json['users'].size).to eq 2
      end

      it 'return users except current resource owner' do
        json['users'].each do |user|
          expect(user['id']).to_not eq owner.id
        end
      end

      it_behaves_like 'API private fields'

      it_behaves_like 'API public fields' do
        let(:user)  { users.second }
      end      
    end
  end
end
 