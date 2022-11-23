require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/admin/users.json').to route_to('api/v1/admin/users#index', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/admin/users/test/delete.json').to route_to('api/v1/admin/users#destroy', username: 'test', format: 'json')
    end
  end
end
