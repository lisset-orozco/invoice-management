# frozen_string_literal: true

module RequestHelper
  def json_body
    @json_body ||= JSON.parse(response.body)
  end

  def request(http_method, endpoint, parameters = nil)
    public_send(http_method, endpoint, params: parameters&.to_json || {}, headers: build_headers)
  end

  def request_auth(http_method, endpoint, token_params, parameters = nil)
    public_send(http_method, endpoint, params: parameters&.to_json || {}, headers: build_headers(token_params))
  end

  def build_headers(token_params = nil)
    headers = {}
    headers['Authorization'] = generate_token(token_params) if token_params.present?
    headers['Content-Type'] = 'application/json'
    headers
  end

  def generate_token(token_params)
    token = Auth::GenerateJwtUtil.call(user_id: token_params[:user_id], email: token_params[:email]).payload
    "Bearer #{token}"
  end
end
