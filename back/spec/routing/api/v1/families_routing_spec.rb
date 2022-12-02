require 'rails_helper'

RSpec.describe Api::V1::FamiliesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/families.json').to route_to('api/v1/families#index', format: 'json')
    end
    it 'routes to #create' do
      expect(post: '/api/v1/families/create.json').to route_to('api/v1/families#create', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/families/1/delete.json').to route_to('api/v1/families#destroy', id: '1', format: 'json')
    end
  end
end
