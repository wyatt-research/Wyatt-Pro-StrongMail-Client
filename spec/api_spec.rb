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
      VCR.use_cassette('member_create_invalid_auth_token') do
        api = Strongmail::API.new(@base_url, 'not a valid token')
        expect { api.fetch_or_create_member(email: 'user@test.com') }.to raise_error(Strongmail::ConfigurationError, 'The auth_token provided is invalid')
      end
    end

    it "throws error if invalid email" do
      VCR.use_cassette('member_create_invalid_email') do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        expect { api.fetch_or_create_member(email: 'this_is_a_bad_email') }.to raise_error(Strongmail::BadRequestError, 'There was an error validating one or more attributes for the requested member.')
      end
    end

    it "returns member if created" do
      VCR.use_cassette('member_create_valid') do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.fetch_or_create_member(email: 'user@example.com')
        expect(member).to be_a(Strongmail::Member)
        expect(member.email).to eq 'user@example.com'
      end
    end

    it "fetches created member" do
      VCR.use_cassette('fetch_created_member') do
        api = Strongmail::API.new(@base_url, @test_auth_token)
        member = api.fetch_or_create_member(email: 'user@example.com')
        expect(member).to be_a(Strongmail::Member)
        expect(member.email).to eq 'user@example.com'
      end
    end
  end

  describe "subscribe member" do

  end

end