# frozen_string_literal: true

module Auth
  class JwtBase < ApplicationUtil
    JWT_SECRET = 'example'
    ALGORITHM = 'HS256'

    private_constant :JWT_SECRET
    private_constant :ALGORITHM

    def initialize(params)
      super()

      @params = params
    end

    private

    attr_reader :params
  end
end
