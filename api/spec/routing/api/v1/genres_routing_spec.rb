require 'rails_helper'

RSpec.describe Api::V1::GenresController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/genres.json').to route_to('api/v1/genres#index', format: 'json')
    end
    it 'routes to #show' do
      expect(get: '/api/v1/genres/1.json').to route_to('api/v1/genres#show', id: '1', format: 'json')
    end
  end
end
