require 'rails_helper'

RSpec.describe Api::V1::PrefecturesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/prefectures.json').to route_to('api/v1/prefectures#index', format: 'json')
    end
  end
end
