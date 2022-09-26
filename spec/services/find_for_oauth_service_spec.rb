require 'rails_helper'

RSpec.describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth)  { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
  subject     { FindForOauthService.new(auth) }

  context 'user already has authorization' do
    it 'returns the user' do
      user.oauth_providers.create(provider: 'github', uid: '123456')

      expect(subject.call).to eq user
    end
  end

  context 'user has not oauth_providers' do
    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates oauth_provider for user' do
        expect { subject.call }.to change(user.oauth_providers, :count).by(1)
      end

      it 'creates oauth_provider with correct provider and uid' do
        oauth_provider = subject.call.oauth_providers.first

        expect(oauth_provider.provider).to eq auth.provider
        expect(oauth_provider.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist and receive oauth_provider with email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills user email' do
        user = subject.call
        expect(user.email).to eq 'new@user.com'
      end

      it 'create oauth_provider for user' do 
        user = subject.call
        expect(user.oauth_providers).to_not be_empty
      end

      it 'create oauth_provider with correct provider and uid' do
        oauth_provider = subject.call.oauth_providers.first

        expect(oauth_provider.provider).to eq auth.provider
        expect(oauth_provider.uid).to eq auth.uid
      end
    end

    context 'user does not exist and receive oauth_provider without email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: nil }) }

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'returns new user' do
        expect(subject.call).to be_a_new(User)
      end
    end
  end
end
