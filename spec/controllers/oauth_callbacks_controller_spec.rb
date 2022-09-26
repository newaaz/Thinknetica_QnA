require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do 

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'sign_in_with_provider' do

    let(:oauth_data)  { mock_auth_hash(:github, 'user@email.com') }

    before { @request.env['omniauth.auth'] = :oauth_data }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists (provider with email)' do
      let!(:user) { create(:user) } 

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
    
    context 'user empty (provider without email)' do
      let(:oauth_data)  { mock_auth_hash(:vkontakte) }

      before do
        @request.env['omniauth.auth'] = :oauth_data

        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to ask email path if provider without email' do  
        expect(response).to redirect_to new_user_path
      end

      it 'does not login user' do     
        expect(subject.current_user).to_not be
      end

      it 'set correct session keys' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get :vkontakte

        expect(session[:oauth_provider]).to eq 'vkontakte'
        expect(session[:oauth_uid]).to eq '123545'
      end
    end

  end


 
end
