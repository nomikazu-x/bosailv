require 'rails_helper'

RSpec.describe Api::V1::EmergencyContactsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/emergency_contacts.json').to route_to('api/v1/emergency_contacts#index', format: 'json')
    end
    it 'routes to #create' do
      expect(post: '/api/v1/emergency_contacts/create.json').to route_to('api/v1/emergency_contacts#create', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/emergency_contacts/1/delete.json').to route_to('api/v1/emergency_contacts#destroy', id: '1', format: 'json')
    end
  end
end
