require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'POST #search' do
    context 'query with global search' do    
      it 'search in all resources' do
        expect(ThinkingSphinx).to receive(:search).with('foobar')        
        post :search, params: { search_query: 'foobar', resources: ["", "All"] }
      end

      it 'renders search view' do
        post :search, params: { search_query: 'foobar', resources: ["", "All"] }
        expect(response).to render_template :search
      end    
    end

    context 'query with one resource search' do
      it 'search in one resource' do
        expect(Question).to receive(:search).with('foobar')        
        post :search, params: { search_query: 'foobar', resources: ["", "Question"] }
      end
    end

    context 'query with one resource search' do
      it 'search in multiple resources' do
        expect(Question).to receive(:search).with('foobar')
        expect(Answer).to receive(:search).with('foobar')        
        post :search, params: { search_query: 'foobar', resources: ["", "Question", "Answer"] }
      end
    end
  end
end
