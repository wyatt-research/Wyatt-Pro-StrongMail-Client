module Strongmail
  autoload :Forwardable, 'forwardable'
  autoload :OpenStruct, 'ostruct'
  autoload :API, 'strongmail/api'
  autoload :Member, 'strongmail/resources'
  autoload :Subscription, 'strongmail/resources'
  autoload :Version, 'strongmail/version'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.fetch_member(email)
    api.fetch_member email
  end

  def self.create_member(member_attr)
    api.create_member member_attr
  end

  def self.update_member(member)
    api.update_member member
  end

  def self.fetch_subscriptions(member, lists = nil)
    api.fetch_subscriptions member, lists
  end

  def self.subscribe(member, lists)
    api.subscribe member, lists
  end

  def self.unsubscribe(member, lists)
    api.unsubscribe member, lists
  end

  def self.api
    @api ||= API.new(configuration.base_url, configuration.auth_token)
  end
  private_class_method :api

  class Configuration

    attr_accessor :auth_token, :environment, :api_host, :api_port

    def initialize
      @environment = :development
    end

    def base_url
      return nil if api_host.nil? || api_port.nil?
      "#{@api_host}:#{@api_port}/v1"
    end

  end

  class Error < ::StandardError
  end

  class ImmutablePropertyError < Error
  end

  class BadRequestError < Error
  end

  class MethodNotAllowedError < Error
  end

  class NotFoundError < Error
  end

  class ConflictError < Error
  end

  class ConfigurationError < Error
  end

end
