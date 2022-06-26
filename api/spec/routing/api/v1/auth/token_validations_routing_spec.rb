require 'rails_helper'

RSpec.describe Api::V1::Auth::TokenValidationsController, type: :routing do
  describe 'routing' do
    it 'routes to #validate_token' do
      expect(get: '/api/v1/auth/validate_token.json').to route_to('api/v1/auth/token_validations#validate_token', format: 'json')
    end
  end
end
