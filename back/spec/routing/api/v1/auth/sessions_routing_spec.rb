require 'rails_helper'

RSpec.describe Api::V1::Auth::SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/auth/sign_in.json').to route_to('api/v1/auth/sessions#create', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/auth/sign_out.json').to route_to('api/v1/auth/sessions#destroy', format: 'json')
    end
  end
end
