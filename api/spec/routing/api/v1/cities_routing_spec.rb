require 'rails_helper'

RSpec.describe Api::V1::CitiesController, type: :routing do
  describe 'routing' do
    it 'routes to #set_cities' do
      expect(post: '/api/v1/set_cities.json').to route_to('api/v1/cities#set_cities', format: 'json')
    end
  end
end
