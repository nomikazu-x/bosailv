require 'rails_helper'

RSpec.describe Api::V1::HazardMapsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/v1/hazard_map.json').to route_to('api/v1/hazard_maps#show', format: 'json')
    end
  end
end
