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
end
