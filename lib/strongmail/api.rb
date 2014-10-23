require 'faraday'
require 'json'
require 'uri'

module Strongmail
  class API

    def initialize(base_url, auth_token)
      guard_api_configuration base_url, auth_token
      @base_url = base_url
      @auth_token = auth_token
      @conn = Faraday.new(url: @base_url)
      @conn.token_auth @auth_token
    end

    def fetch_or_create_member(member_attr)
      member = fetch_member member_attr[:email]
      if member.nil?
        member = create_member member_attr
      end

      member
    end

    def update_member(member)

    end

    def fetch_subscriptions(member, lists = nil)
    end

    def subscribe(member, lists)
    end

    def unsubscribe(member, lists)
    end

    private

    def prepare_request(req)
      req.headers["Accept"] = "application/json"
      req.headers["Content-Type"] = "application/json"
    end

    def fetch_member(email)
      response = @conn.get do |req|
        req.url "members/#{email}"
        prepare_request req
      end

      begin
        body = JSON.parse response.body
        guard_error_response response, body
      rescue Strongmail::NotFoundError
        return nil
      end

      Strongmail::Member.new body['_payload']
    end

    def create_member(member_attr)
      response = @conn.post do |req|
          req.url "members"
          prepare_request req

          req.body = member_attr.to_json
        end

        body = JSON.parse response.body
        guard_error_response response, body
        Strongmail::Member.new body['_payload']
    end

    def guard_error_response(response, body)
      case response.status
      when 400
        raise Strongmail::BadRequestError.new body['_meta']['message']
      when 401
        raise Strongmail::ConfigurationError.new "The auth_token provided is invalid"
      when 404
        raise Strongmail::NotFoundError.new body['_meta']['message']
      when 406
        raise Strongmail::MethodNotAllowedError.new body['_meta']['message']
      when 409
        raise Strongmail::ConflictError.new body['_meta']['message']
      end
    end

    def guard_api_configuration(base_url, auth_token)
      raise Strongmail::ConfigurationError.new("The base_url provided must be a valid URI string") if !url_valid?(base_url)
      raise Strongmail::ConfigurationError.new("The auth_token provided must be a valid string") if auth_token.nil?
    end

    def url_valid?(base_url)
      !!URI.parse(base_url)
    rescue URI::InvalidURIError
      false
    end

  end
end