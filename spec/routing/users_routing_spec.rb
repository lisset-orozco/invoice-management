# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(V1::UsersController, type: :routing) do
  describe 'routing' do
    it 'routes to #create' do
      path = { post: 'v1/users' }
      expect(path).to route_to('v1/users#create')
    end
  end
end
