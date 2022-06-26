require 'rails_helper'

RSpec.describe Api::V1::Auth::UnlocksController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/auth/unlock.json').to route_to('api/v1/auth/unlocks#create', format: 'json')
    end
    it 'routes to #show' do
      expect(get: '/api/v1/auth/unlock.json').to route_to('api/v1/auth/unlocks#show', format: 'json')
    end
  end
end
