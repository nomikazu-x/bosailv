require 'rails_helper'

RSpec.describe Api::V1::Auth::RegistrationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/auth/sign_up.json').to route_to('api/v1/auth/registrations#create', format: 'json')
    end
    it 'routes to #show' do
      expect(get: '/api/v1/auth/detail.json').to route_to('api/v1/auth/registrations#show', format: 'json')
    end
    it 'routes to #update' do
      expect(post: '/api/v1/auth/update.json').to route_to('api/v1/auth/registrations#update', format: 'json')
    end
    it 'routes to #profile_update' do
      expect(post: '/api/v1/auth/profile/update.json').to route_to('api/v1/auth/registrations#profile_update', format: 'json')
    end
    it 'routes to #image_update' do
      expect(post: '/api/v1/auth/image/update.json').to route_to('api/v1/auth/registrations#image_update', format: 'json')
    end
    it 'routes to #image_destroy' do
      expect(post: '/api/v1/auth/image/delete.json').to route_to('api/v1/auth/registrations#image_destroy', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/auth/delete.json').to route_to('api/v1/auth/registrations#destroy', format: 'json')
    end
  end
end
