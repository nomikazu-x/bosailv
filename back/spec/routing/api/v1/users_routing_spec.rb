require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/users.json').to route_to('api/v1/users#index', format: 'json')
    end
    it 'routes to #show' do
      expect(get: '/api/v1/users/test.json').to route_to('api/v1/users#show', username: 'test', format: 'json')
    end
  end
end
