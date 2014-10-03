require 'faraday'
require 'json'

module Darna
  @@api_key = nil
  @@api_url = 'http://darna-app.herokuapp.com'

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.get_request url
    response = conn.get "#{url}?auth_token=#{api_key}"
    JSON.parse response.body
  end

  def self.post_request url, params
    response = conn.post do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.body = params.merge(auth_token: api_key).to_json
    end
    JSON.parse response.body
  end

  def self.get_thing project, thing_slug
    get_request "/api/p/#{project}/#{thing_slug}"
  end

  def self.create_thing project, params
    post_request "/api/p/#{project}", params
  end


  private


  def self.conn
    Faraday.new(url: @@api_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end
