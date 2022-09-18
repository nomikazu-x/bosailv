require 'rails_helper'

RSpec.describe Api::V1::Auth::PasswordsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(post: '/api/v1/auth/password.json').to route_to('api/v1/auth/passwords#create', format: 'json')
    end
    it 'routes to #edit' do
      expect(get: '/api/v1/auth/password.json').to route_to('api/v1/auth/passwords#edit', format: 'json')
    end
    it 'routes to #update' do
      expect(post: '/api/v1/auth/password/update.json').to route_to('api/v1/auth/passwords#update', format: 'json')
    end
  end
end
