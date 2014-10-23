module Strongmail
  class Resource
    extend Forwardable

    def initialize(data = {})
      @data = OpenStruct.new data
    end

    private

    def guard_readonly_property
      resource = self.class.name.split('::').last
      raise Strongmail::ImmutablePropertyError.new("You may not change that #{resource} attribute")
    end
  end

  class Member < Resource

    # Readonly Proprties
    def_delegators :@data, :id, :email, :email_status
    def_delegators :guard_readonly_property, :id=, :email=, :date_joined=, :email_status=

    # Read and Write Properties
    def_delegators :@data, :first_name, :first_name=, :last_name, :last_name=,
                           :address1, :address1=, :address2, :address2=, :city, :city=,
                           :state, :state=, :zip, :zip=, :country, :country=, :work_phone, :work_phone=


    def date_joined
      DateTime.parse @data.date_joined
    end

  end

  class Subscription < Resource

    # Readonly Properties
    def_delegators :@data, :id, :member_email, :list
    def_delegators :guard_readonly_property, :id=, :active=, :member_email=, :list=, :date_subscribed=,
                                             :date_unsubscribed=

    def active?
      @data.active
    end

    def date_subscribed
      DateTime.parse @data.date_subscribed
    end

    def date_unsubscribed
      @data.date_unsubscribed.nil? ? nil : DateTime.parse(@data.date_unsubscribed)
    end

  end

end