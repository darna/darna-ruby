require 'faraday'

module Darna
  @@api_key = nil
  @@api_url = 'http://darna-app.herokuapp.com/api/p/'

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.get_request url
    response = conn.get "#{url}?auth_url=#{api_key}"
    response.body
  end

  def self.post_request url, params
    response = conn.post url, params.merge(auth_url: api_key)
    response.body
  end

  def self.get_thing project, thing_slug
    get_request "/#{project}/#{thing_slug}"
  end

  def self.create_thing project, params
    post_request "/#{project}", params
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
