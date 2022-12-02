require 'rails_helper'

RSpec.describe Api::V1::StocksController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/stocks.json').to route_to('api/v1/stocks#index', format: 'json')
    end
  end
end
