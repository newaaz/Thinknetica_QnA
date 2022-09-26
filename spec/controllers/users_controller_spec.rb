require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:award)   { create(:award, question: question, user: user) }

  describe 'GET #awards' do
    before { login(user) } 

    before { get :awards, params: { id: user } }
    it 'renders award view' do
      expect(response).to render_template :awards
    end

    it 'assigns awards' do
      expect(assigns(:awards)[0]).to eq award
    end
  end

  describe 'GET #new_user' do
    before { get :new }

    it 'assigns a new User to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end   

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create_user' do

    before do
      session[:oauth_provider] = 'github'
      session[:oauth_uid] = '123'
    end

    context 'with valid email' do
      it 'send_confirmation_instructions' do
        post :create, params: { user: { email: 'new@user.com' } }
        mail = find_mail_to('new@user.com')
        expect(mail.subject).to eq 'Confirmation instructions'
      end

      it 'saves a new user in the DB' do
        expect { post :create, params: { user: { email: 'new@user.com' } } }.to change(User, :count).by(1)
      end

      it 'redirect to root path' do
        post :create, params: { user: { email: 'new@user.com' } }
        expect(response).to redirect_to root_path
      end

      it 'create user with correct email' do
        post :create, params: { user: { email: 'new@user.com' } }
        expect(User.last.email).to eq 'new@user.com'
      end

      it 'create correct oauth_provider' do
        post :create, params: { user: { email: 'new@user.com' } }
        expect(User.last.oauth_providers.first.provider).to eq 'github'
        expect(User.last.oauth_providers.first.uid).to eq '123'
      end
    end

    context 'with invalid email' do
      it 'does not save the user in the DB' do
        expect { post :create, params: { user: { email: '' } } }.to_not change(User, :count)
      end

      it 're-renders new view' do
        post :create, params: { user: { email: '' } }
        expect(response).to render_template :new
      end
    end
  end

  def find_mail_to(email)
    ActionMailer::Base.deliveries.find { |mail| mail.to.include?(email) }
  end
end
