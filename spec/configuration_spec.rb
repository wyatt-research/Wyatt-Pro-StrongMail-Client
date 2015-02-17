RSpec.describe Strongmail::Configuration do

  before(:each) do
    @config = Strongmail::Configuration.new
  end

  describe "#auth_token" do
    it "defaults to nil" do
      expect(@config.auth_token).to be_nil
    end

    it "can set value" do
      @config.auth_token = 'my_token'
      expect(@config.auth_token).to eq 'my_token'
    end
  end

  describe "#api_host" do
    it "defaults to nil" do
      expect(@config.api_host).to be_nil
    end

    it "can set value" do
      @config.api_host = 'localhost'
      expect(@config.api_host).to eq 'localhost'
    end
  end

  describe "#base_url" do
    it "defaults to nil" do
      expect(@config.base_url).to be_nil
    end

    it "determines value from api_host" do
      @config.api_host = 'http://localhost'
      expect(@config.base_url).to eq 'http://localhost/v1'
    end
  end
end