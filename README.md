# Strongmail

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'strongmail', github: 'wyatt-research/Wyatt-Pro-StrongMail-Client'

And then execute:

    $ bundle

## Usage

### Configuration

Before you can make requests to the API you must provide a minimal amount of configuration.

```ruby
require 'strongmail'

Strongmail.configure do |config|
  config.api_host = 'http://your.smapi.host'
  config.api_port = 3000
  config.auth_token = 'my_api_auth_token'
end
```

Without at least these configuration values the client will throw errors if you attempt to make any requests.

> We have you specify the api_host and api_port to easily allow this client to be used in test, development, staging, and production environments.

The below examples that detail making calls assume that you have provided valid configuration values.

### Create Member
