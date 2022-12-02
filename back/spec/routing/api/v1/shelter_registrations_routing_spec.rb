require 'rails_helper'

RSpec.describe Api::V1::ShelterRegistrationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/shelters/1/shelter_registrations/create.json').to route_to('api/v1/shelter_registrations#create', id: '1', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/shelters/1/shelter_registrations/delete.json').to route_to('api/v1/shelter_registrations#destroy', id: '1', format: 'json')
    end
  end
end
