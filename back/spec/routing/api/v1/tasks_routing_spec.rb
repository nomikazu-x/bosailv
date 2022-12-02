require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/tasks.json').to route_to('api/v1/tasks#index', format: 'json')
    end
    it 'routes to #show' do
      expect(get: '/api/v1/tasks/1.json').to route_to('api/v1/tasks#show', id: '1', format: 'json')
    end
  end
end
