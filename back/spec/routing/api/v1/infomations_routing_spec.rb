require 'rails_helper'

RSpec.describe Api::V1::InfomationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/infomations.json').to route_to('api/v1/infomations#index', format: 'json')
    end
    it 'routes to #important' do
      expect(get: '/api/v1/infomations/important.json').to route_to('api/v1/infomations#important', format: 'json')
    end
    it 'routes to #show' do
      expect(get: '/api/v1/infomations/1.json').to route_to('api/v1/infomations#show', id: '1', format: 'json')
    end
  end
end
