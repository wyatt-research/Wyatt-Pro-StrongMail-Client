RSpec.describe Strongmail::API do

  before do
    @base_url = 'http://192.168.33.10:3000/v1'
    @test_auth_token = '6acbf3171ac7990a84e3c8237a092c4d'
  end

  describe "invalid credentials" do
    it "throws error if base_url is not a URI" do
      expect { Strongmail::API.new('obviously not a uri', 'token') }.to raise_error(Strongmail::ConfigurationError, 'The base_url provided must be a valid URI string')
    end

    it "throws error if auth_token is nil" do
      expect { Strongmail::API.new('http://localhost', nil) }.to raise_error(Strongmail::ConfigurationError, 'The auth_token provided must be a valid string')
    end
  end

  describe "create member" do
    it "throws errors if invalid auth_token" do
      VCR.use_cassette('create_member_invalid_auth_token') do
        api = Strongmail::API.new(@base_url, 'not a valid token')
        expect { api.create_member(email: 'user@test.com') }.to raise_error(Strongmail::ConfigurationError, 'The auth_token provided is invalid')
      end
    end

    it "throws error if invalid email" do
      VCR.use_cassette('create_member_invalid_email') do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        expect { api.create_member(email: 'this_is_a_bad_email') }.to raise_error(Strongmail::BadRequestError, 'There was an error validating one or more attributes for the requested member.')
      end
    end

    it "returns member if created" do
      VCR.use_cassette('create_member') do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.create_member(email: 'user@example.com', first_name: 'Jon', last_name: 'Doe')
        expect(member).to be_a(Strongmail::Member)
        expect(member.email).to eq 'user@example.com'
        expect(member.first_name).to eq 'Jon'
        expect(member.last_name).to eq 'Doe'
      end
    end

    it "throws error if member already created" do
      VCR.use_cassette('create_member_duplicate_email') do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        expect { api.create_member(email: 'user@example.com') }.to raise_error(Strongmail::ConflictError, 'A member with that email already exists.')
      end
    end
  end

  describe "#fetch_member" do
    it "throws errors if invalid auth_token" do
      VCR.use_cassette('fetch_member_invalid_auth_token') do
        api = Strongmail::API.new(@base_url, 'not a valid token')
        expect { api.fetch_member('user@test.com') }.to raise_error(Strongmail::ConfigurationError, 'The auth_token provided is invalid')
      end
    end

    it "throws error if member not found" do
      VCR.use_cassette('fetch_member_not_found') do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        expect { api.fetch_member('not_found@example.com') }.to raise_error(Strongmail::NotFoundError, 'User with email not_found@example.com could not be found.')
      end
    end

    it "fetches created member" do
      VCR.use_cassette('fetch_member') do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.fetch_member('user@example.com')
        expect(member).to be_a(Strongmail::Member)
        expect(member.email).to eq 'user@example.com'
      end
    end
  end

  describe "#update_member" do
    it "throws error if member is not a Strongmail::Member" do
      api = Strongmail::API.new(@base_url, @test_auth_token)
      expect { api.update_member('not a Strongmail::Member') }.to raise_error(Strongmail::BadRequestError, 'To update a member you must pass a Strongmail::Member object')
    end

    it "throws error if invalid auth_token" do
      VCR.use_cassette('update_member_invalid_auth_token') do
        member = Strongmail::Member.new(email: 'does_not_matter@example.com')
        api = Strongmail::API.new(@base_url, 'not a valid token')
        expect { api.update_member(member) }.to raise_error(Strongmail::ConfigurationError, 'The auth_token provided is invalid')
      end
    end

    it "throws error if member not found" do
      VCR.use_cassette('update_member_not_found') do
        member = Strongmail::Member.new(email: 'not_found@example.com')
        api = Strongmail::API.new(@base_url, @test_auth_token)
        expect { api.update_member(member) }.to raise_error(Strongmail::NotFoundError, 'User with email not_found@example.com could not be found.')
      end
    end

    it "updates all updateable properties" do
      VCR.use_cassette('update_member') do
        api = Strongmail::API.new(@base_url, @test_auth_token)

        member = api.fetch_member 'user@example.com'
        member.first_name = 'Neil'
        member.last_name = 'deGrasse Tyson'
        member.address1 = '1234 Scientist Way'
        member.address2 = 'Ste. 42'
        member.city = 'Intelligenceville'
        member.state = 'VT'
        member.country = 'USA'
        member.zip = '12345'
        member.work_phone = '555-555-5555'

        updated_member = api.update_member member

        expect(updated_member).to be_a(Strongmail::Member)
        expect(updated_member.id).to eq member.id
        expect(updated_member.email).to eq member.email
        expect(updated_member.first_name).to eq 'Neil'
        expect(updated_member.last_name).to eq 'deGrasse Tyson'
        expect(updated_member.address1).to eq '1234 Scientist Way'
        expect(updated_member.address2).to eq 'Ste. 42'
        expect(updated_member.city).to eq 'Intelligenceville'
        expect(updated_member.state).to eq 'VT'
        expect(updated_member.country).to eq 'USA'
        expect(updated_member.zip).to eq '12345'
        expect(updated_member.work_phone).to eq '555-555-5555'
      end
    end
  end

  describe "#subscribe" do
    it "throws error if member is not a Strongmail::Member" do
      api = Strongmail::API.new(@base_url, @test_auth_token)
      expect { api.subscribe('not a member', ['lists']) }.to raise_error(Strongmail::BadRequestError, 'To subscribe a member you must pass a Strongmail::Member object')
    end

    it "throws error if lists is not an Array" do
      api = Strongmail::API.new(@base_url, @test_auth_token)
      member = Strongmail::Member.new
      expect { api.subscribe(member, 'not an array') }.to raise_error(Strongmail::BadRequestError, 'You must pass an array of lists to subscribe to')
    end

    it "throws error if member not found" do
      VCR.use_cassette("subscribe_member_not_found") do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = Strongmail::Member.new(email: 'not_found@example.com')
        expect { api.subscribe(member, ['list']) }.to raise_error(Strongmail::BadRequestError, 'Could not find a user matching "not_found@example.com"')
      end
    end

    it "creates appropriate subscription" do
      VCR.use_cassette("subscribe_member") do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.fetch_member('user@example.com')
        lists = ['foo', 'foo_offer', 'something_else']
        subscriptions = api.subscribe member, lists

        expect(subscriptions).to be_a(Array)
        expect(subscriptions[0]).to be_a(Strongmail::Subscription)
        expect(subscriptions[1]).to be_a(Strongmail::Subscription)
        expect(subscriptions[2]).to be_a(Strongmail::Subscription)

        expect(subscriptions[0].member_email).to eq member.email
        expect(subscriptions[1].member_email).to eq member.email
        expect(subscriptions[2].member_email).to eq member.email

        expect(subscriptions[0].list).to eq 'foo'
        expect(subscriptions[1].list).to eq 'foo_offer'
        expect(subscriptions[2].list).to eq 'something_else'
      end
    end

    it "throws error if resubscribing" do
      VCR.use_cassette("subscribe_member_already_subscribed") do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.fetch_member('user@example.com')
        lists = ['foo', 'bar']
        expect { api.subscribe(member, lists) }.to raise_error(Strongmail::ConflictError, 'The user with email address user@example.com is already subscribed to one or more of the lists provided')
      end
    end
  end

  describe "#fetch_subscriptions" do
    it "throws error if member is not a Strongmail::Member" do
      api = Strongmail::API.new(@base_url, @test_auth_token)
      expect { api.fetch_subscriptions('not a member') }.to raise_error(Strongmail::BadRequestError, 'To fetch a member\'s subscriptions you must pass a Strongmail::Member object')
    end

    it "throws error if lists is present and not an array" do
      api = Strongmail::API.new(@base_url, @test_auth_token)
      member = Strongmail::Member.new(email: 'some@email.com')
      expect { api.fetch_subscriptions(member, 'not an array')}.to raise_error(Strongmail::BadRequestError, 'To fetch a member\'s specific subscription you must pass an Array of list names')
    end

    it "throws error if invalid auth_token" do
      VCR.use_cassette("fetch_subscriptions_invalid_auth_token") do
        api = Strongmail::API.new(@base_url, 'invalid token')
        member = Strongmail::Member.new(email: 'some@email.com')
        expect { api.fetch_subscriptions(member) }.to raise_error(Strongmail::ConfigurationError, 'The auth_token provided is invalid')
      end
    end

    it "fetches all subscriptions if lists is nil" do
      VCR.use_cassette("fetch_subscriptions_all") do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.fetch_member('user@example.com')
        subscriptions = api.fetch_subscriptions member

        expect(subscriptions).to be_a(Array)
        expect(subscriptions[0]).to be_a(Strongmail::Subscription)
        expect(subscriptions[1]).to be_a(Strongmail::Subscription)
        expect(subscriptions[2]).to be_a(Strongmail::Subscription)

        expect(subscriptions[0].member_email).to eq member.email
        expect(subscriptions[1].member_email).to eq member.email
        expect(subscriptions[2].member_email).to eq member.email

        expect(subscriptions[0].list).to eq 'foo'
        expect(subscriptions[1].list).to eq 'foo_offer'
        expect(subscriptions[2].list).to eq 'something_else'
      end
    end

    it "fetches only requests subscriptions if lists is an Array" do
      VCR.use_cassette("fetch_subscriptions_specific") do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.fetch_member('user@example.com')
        subscriptions = api.fetch_subscriptions member, ['foo_offer', 'something_else']

        expect(subscriptions).to be_a(Array)
        expect(subscriptions[0]).to be_a(Strongmail::Subscription)
        expect(subscriptions[0].member_email).to eq member.email
        expect(subscriptions[0].list).to eq 'foo_offer'

        expect(subscriptions[1]).to be_a(Strongmail::Subscription)
        expect(subscriptions[1].member_email).to eq member.email
        expect(subscriptions[1].list).to eq 'something_else'
      end
    end
  end

  describe "#unsubscribe" do
    it "throws error if member is not a Strongmail::Member" do
      api = Strongmail::API.new(@base_url, @test_auth_token)
      expect { api.unsubscribe('not a member', ['lists']) }.to raise_error(Strongmail::BadRequestError, 'To unsubscribe a member you must pass a Strongmail::Member object')
    end

    it "throws error if lists is not an Array" do
      api = Strongmail::API.new(@base_url, @test_auth_token)
      member = Strongmail::Member.new(email: 'something@test.com')
      expect { api.unsubscribe(member, 'not an array') }.to raise_error(Strongmail::BadRequestError, 'You must pass an array of lists to unsubscribe from')
    end

    it "throws error if invalid auth_token" do
      VCR.use_cassette("unsubscribe_invalid_auth_token") do
        api = Strongmail::API.new(@base_url, 'invalid token')
        member = Strongmail::Member.new(email: 'some@email.com')
        expect { api.unsubscribe(member, ['list']) }.to raise_error(Strongmail::ConfigurationError, 'The auth_token provided is invalid')
      end
    end

    it "unsubscribes a given publication list" do
      VCR.use_cassette("unsubscribe_member") do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.fetch_member('user@example.com')
        api.unsubscribe(member, ['something_else'])
        subscriptions = api.fetch_subscriptions member, ['something_else']

        expect(subscriptions[0]).to be_a(Strongmail::Subscription)
        expect(subscriptions[0].member_email).to eq member.email
        expect(subscriptions[0].list).to eq 'something_else'
        expect(subscriptions[0].active?).not_to be
      end
    end
  end

end