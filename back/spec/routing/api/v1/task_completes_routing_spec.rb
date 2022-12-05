require 'rails_helper'

RSpec.describe Api::V1::TaskCompletesController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/tasks/1/task_completes/create.json').to route_to('api/v1/task_completes#create', id: '1', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/tasks/1/task_completes/delete.json').to route_to('api/v1/task_completes#destroy', id: '1', format: 'json')
    end
  end
end
