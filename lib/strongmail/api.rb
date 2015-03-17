require 'faraday'
require 'json'
require 'uri'

module Strongmail
  class API

    def initialize(base_url, auth_token)
      guard_api_configuration base_url, auth_token
      @conn = Faraday.new(url: base_url)
      @conn.token_auth auth_token
    end

    def fetch_member(email)
      response = @conn.get do |req|
        prepare_request req
        req.url "members/#{email}"
      end

      body = JSON.parse response.body
      guard_error_response response, body

      Strongmail::Member.new body['_payload']
    end

    def create_member(member_attr)
      response = @conn.post do |req|
          prepare_request req
          req.url "members"
          req.body = member_attr.to_json
        end

        body = JSON.parse response.body
        guard_error_response response, body
        Strongmail::Member.new body['_payload']
    end

    def change_email_member(member)
      raise Strongmail::BadRequestError.new("To update a member email you must pass a Strongmail::Member object") if !member.is_a?(Strongmail::Member)

      response = @conn.patch do |req|
        prepare_request req
        req.url "members/#{member.email}/change_email"
        req.body = get_member_email_attr(member).to_json
      end

      body = JSON.parse response.body
      guard_error_response response, body

      Strongmail::Member.new body['_payload']
    end

    def update_member(member)
      raise Strongmail::BadRequestError.new("To update a member you must pass a Strongmail::Member object") if !member.is_a?(Strongmail::Member)

      response = @conn.patch do |req|
        prepare_request req
        req.url "members/#{member.email}"
        req.body = get_member_update_attr(member).to_json
      end

      body = JSON.parse response.body
      guard_error_response response, body

      Strongmail::Member.new body['_payload']
    end

    def fetch_subscriptions(member, lists = nil)
      raise Strongmail::BadRequestError.new("To fetch a member's subscriptions you must pass a Strongmail::Member object") if !member.is_a?(Strongmail::Member)
      raise Strongmail::BadRequestError.new("To fetch a member's specific subscription you must pass an Array of list names") if !lists.nil? && !lists.is_a?(Array)

      response = @conn.get do |req|
        prepare_request req
        req.url lists.nil? ? "members/#{member.email}/subscriptions" : "members/#{member.email}/subscriptions/#{lists.join(';')}"
      end

      body = JSON.parse response.body
      guard_error_response response, body

      subs = []
      body['_payload'].each do |sub|
        subs << Strongmail::Subscription.new(sub)
      end

      subs
    end

    def subscribe(member, lists)
      raise Strongmail::BadRequestError.new("To subscribe a member you must pass a Strongmail::Member object") if !member.is_a?(Strongmail::Member)
      raise Strongmail::BadRequestError.new("You must pass an array of lists to subscribe to") if !lists.is_a?(Array)

      response = @conn.post do |req|
        prepare_request req
        req.url "members/#{member.email}/subscriptions"
        req.body = {:lists => lists}.to_json
      end

      body = JSON.parse response.body
      guard_error_response response, body

      subs = []
      body['_payload'].each do |sub|
        subs << Strongmail::Subscription.new(sub)
      end

      subs
    end

    def unsubscribe(member, lists)
      raise Strongmail::BadRequestError.new('To unsubscribe a member you must pass a Strongmail::Member object') if !member.is_a?(Strongmail::Member)
      raise Strongmail::BadRequestError.new('You must pass an array of lists to unsubscribe from') if !lists.is_a?(Array)

      response = @conn.delete do |req|
        prepare_request req
        req.url "members/#{member.email}/subscriptions/#{lists.join(';')}"
      end

      # successfully unsubscribing a member from a list returns 204 No Content
      # this check prevents an error from being raised when trying to JSON.parse a nil body
      if response.status != 204
        body = JSON.parse response.body
        guard_error_response response, body
      end
    end

    private

    def get_member_update_attr(member)
      {
        :first_name => member.first_name,
        :last_name => member.last_name,
        :address1 => member.address1,
        :address2 => member.address2,
        :city => member.city,
        :state => member.state,
        :zip => member.zip,
        :country => member.country,
        :work_phone => member.work_phone
      }
    end

    def get_member_email_attr(member)
      {
        :email => member.email
      }
    end

    def prepare_request(req)
      req.headers["Accept"] = "application/json"
      req.headers["Content-Type"] = "application/json"
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