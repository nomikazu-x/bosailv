require 'rails_helper'

RSpec.describe Api::V1::FamilyRulesController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/v1/task_profile.json').to route_to('api/v1/task_profiles#show', format: 'json')
    end
    it 'routes to #update' do
      expect(post: '/api/v1/task_profiles/update.json').to route_to('api/v1/task_profiles#update', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/task_profiles/delete.json').to route_to('api/v1/task_profiles#destroy', format: 'json')
    end
  end
end
