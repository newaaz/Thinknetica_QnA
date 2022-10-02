# Links
shared_examples_for 'API resource links' do
  it 'returns list of links' do
    expect(resource_response['links'].size).to eq 3
  end

  it 'contain correct link' do
    expect(resource_response['links'][0]).to eq links.first.as_json
  end
end

# Comments
shared_examples_for 'API resource comments' do
  it 'returns list of comments' do
    expect(resource_response['comments'].size).to eq 3
  end

  it 'contain correct comment' do
    expect(resource_response['comments'][0]).to eq comment.as_json
  end
end

# Attachments
shared_examples_for 'API resource attachments' do
  it 'returns list of attachmens' do
    expect(resource_response['files'].size).to eq 2
  end

  it 'contain correct attachment' do
    expect(resource_response['files'][0]['name']).to eq 'first_attachment.rb'
    expect(resource_response['files'][0]['url']).to eq Rails.application.routes.url_helpers.rails_blob_url(resource.files.first)
  end
end

# List 
shared_examples_for 'API list of resources' do
  it 'returns list of resources' do
    expect(resources.size).to eq 3
  end
end

# Public fields
shared_examples_for 'API public fields' do
  it 'returns all public fields' do
    %w[id email admin created_at updated_at].each do |attr|
      expect(user_response[attr]).to eq user.send(attr).as_json
    end        
  end
end

# Private fields
shared_examples_for 'API private fields' do
  it 'does not returns private fields' do
    %w[password encrypted_password].each do |attr|
      expect(user_response).to_not have_key(attr)
    end        
  end
end
