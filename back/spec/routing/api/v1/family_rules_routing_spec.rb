require 'rails_helper'

RSpec.describe Api::V1::FamilyRulesController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/v1/family_rule.json').to route_to('api/v1/family_rules#show', format: 'json')
    end
    it 'routes to #create' do
      expect(post: '/api/v1/family_rules/create.json').to route_to('api/v1/family_rules#create', format: 'json')
    end
    it 'routes to #update' do
      expect(post: '/api/v1/family_rules/update.json').to route_to('api/v1/family_rules#update', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/family_rules/delete.json').to route_to('api/v1/family_rules#destroy', format: 'json')
    end
  end
end
