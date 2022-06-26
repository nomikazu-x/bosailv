require 'rails_helper'

RSpec.describe Api::V1::Auth::ConfirmationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/auth/confirmation.json').to route_to('api/v1/auth/confirmations#create', format: 'json')
    end
    it 'routes to #show' do
      expect(get: '/api/v1/auth/confirmation.json').to route_to('api/v1/auth/confirmations#show', format: 'json')
    end
  end
end
