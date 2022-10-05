# Links
shared_examples_for 'API resource linkable' do
  it 'returns list of links' do
    expect(resource_response['links'].size).to eq 3
  end

  it 'contain correct link' do
    expect(resource_response['links'][0]).to eq links.first.as_json
  end
end

# Comments
shared_examples_for 'API resource commentable' do
  it 'returns list of comments' do
    expect(resource_response['comments'].size).to eq 3
  end

  it 'contain correct comment' do
    expect(resource_response['comments'][0]).to eq comment.as_json
  end
end

# Attachments
shared_examples_for 'API resource attachmentable' do
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

# return erorrs on create/update
shared_examples_for 'API return errors on create/update' do
  it 'returns errors' do
    send_invalid_request
    #expect(json['errors']['title'][0]).to eq "can't be blank"
    expect(json['errors']['body'][0]).to eq "can't be blank"
  end
end

# status redirect
shared_examples_for 'API status redirect' do
  it 'status redirect' do
    send_request
    expect(response.status).to eq 302
  end 
end

# destroy question/answer
shared_examples_for 'API deletable' do
  context 'authorized' do
    context 'author of resource' do
      let(:access_token)      { create(:access_token, resource_owner_id: author.id) }
      
      it 'deletes the resource in DB' do
        expect { send_request }.to change(resource.class, :count).by(-1)
      end

      it 'status no content' do
        send_request
        expect(response.status).to eq 204
      end      
    end

    context 'non author of question' do
      let(:non_author)    { create(:user) }
      let(:access_token)  { create(:access_token, resource_owner_id: non_author.id) }

      it 'does not delete question' do
        expect { send_request }.to_not change(resource.class, :count)
      end

      it_behaves_like 'API status redirect'
    end
  end
end
