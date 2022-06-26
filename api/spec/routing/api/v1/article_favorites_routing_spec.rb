require 'rails_helper'

RSpec.describe Api::V1::ArticleFavoritesController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/articles/1/article_favorites/create.json').to route_to('api/v1/article_favorites#create', id: '1', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/articles/1/article_favorites/delete.json').to route_to('api/v1/article_favorites#destroy', id: '1', format: 'json')
    end
  end
end
