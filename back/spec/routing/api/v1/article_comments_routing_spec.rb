require 'rails_helper'

RSpec.describe Api::V1::ArticleCommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/articles/1/article_comments.json').to route_to('api/v1/article_comments#index', article_id: '1', format: 'json')
    end
    it 'routes to #create' do
      expect(post: '/api/v1/articles/1/article_comments/create.json').to route_to('api/v1/article_comments#create', article_id: '1', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/articles/1/article_comments/1/delete.json').to route_to('api/v1/article_comments#destroy', article_id: '1', id: '1', format: 'json')
    end
  end
end
