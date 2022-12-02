require 'rails_helper'

RSpec.describe Api::V1::SheltersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/shelters.json').to route_to('api/v1/shelters#index', format: 'json')
    end
    it 'routes to #show' do
      expect(get: '/api/v1/shelters/1.json').to route_to('api/v1/shelters#show', id: '1', format: 'json')
    end
  end
end
