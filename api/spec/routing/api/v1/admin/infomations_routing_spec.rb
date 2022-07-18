require 'rails_helper'

RSpec.describe Api::V1::Admin::InfomationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/admin/infomations/create.json').to route_to('api/v1/admin/infomations#create', format: 'json')
    end
    it 'routes to #destroy' do
      expect(post: '/api/v1/admin/infomations/1/delete.json').to route_to('api/v1/admin/infomations#destroy', id: '1', format: 'json')
    end
  end
end
