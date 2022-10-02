shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end 
end

shared_examples_for 'API success response' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'API public fields' do
  it 'returns all public fields' do
    %w[id email admin created_at updated_at].each do |attr|
      expect(user_response[attr]).to eq user.send(attr).as_json
    end        
  end
end

shared_examples_for 'API private fields' do
  it 'does not returns private fields' do
    %w[password encrypted_password].each do |attr|
      expect(user_response).to_not have_key(attr)
    end        
  end
end
