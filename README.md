# Strongmail

[![Circle CI](https://circleci.com/gh/wyatt-research/Wyatt-Pro-StrongMail-Client.png?style=badge&circle-token=8d5e9b8f014067cc9dbc5f9c770f50b79044e126)](https://circleci.com/gh/wyatt-research/Wyatt-Pro-StrongMail-Client)

A Ruby client to interact with the Wyatt Research StrongMail API.

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

Without at least these configuration values the client will throw a `Strongmail::ConfigurationError` if you attempt to make any requests.

> We have you specify the api_host and api_port to easily allow this client to be used in test, development, staging, and production environments.

The below examples assume that you have provided valid configuration values.

### Create Member

Creating a member is as simple as passing a hash to `Strongmail.create_member`. If the user was successfully created a `Strongmail::Member` object will be returned that represents the newly created member. When creating a member you are only required to pass the 'email' attribute but can pass any other updateable attribute as well.

```ruby
require 'strongmail'

member = Strongmail.create_member(email: 'user@example.com', first_name: 'Jon', last_name: 'Doe')
Strongmail.create_member(email: 'bad email address')    # raises Strongmail::BadRequestError
Strongmail.create_member(email: 'user@example.com')     # raises Strongmail::ConflictError
```

### Fetching a Member

The StrongMail API allows you to fetch a single Member at a time for a given email address. The API client allows you to do this by calling `Strongmail.fetch_member`.

```ruby
require 'strongmail'

member = Strongmail.fetch_member('user@example.com')
Strongmail.fetch_member('not_found@example.com')      # raises Strongmail::NotFoundError
```

### Subscribe a Member to a List

Subscribing a member to a list is accomplished by passing a `Strongmail::Member` object and an `Array` of list names you'd like to subscribe the Member to. We return an `Array` of `Strongmail::Subscription` objects that are associated to this user.

If you do not pass a `Strongmail::Member` and an `Array` to this function an error will be raised.

```ruby
require 'strongmail'

member = Strongmail.fetch_member('user@example.com')
sm_subs = Strongmail.subscribe(member, ['foo_list', 'bar_list', 'baz_list'])
```

### Fetching Subscriptions

It is easy to fetch subscriptions for a given Member by calling `Strongmail.fetch_subscriptions`. Like Subscribing a Member you must pass a `Strongmail::Member` to the first argument of this function. If you do not pass a set of lists to pull from all subscriptions for that Member will be returned.


```ruby
require 'strongmail'

member = Strongmail.fetch_member('user@example.com')
no_subs_member = Strongmail.fetch_member('no_subs@example.com')
all_sm_subs = Strongmail.fetch_subscriptions(member)                            # An Array of Strongmail::Subscription
some_subs = Strongmail.fetch_subscriptions(member, ['bar_list', 'baz_list'])    # An Array of Strongmail::Subscription
one_sub = Strongmail.fetch_subscriptions(member, ['foo_list'])                  # An array of Strongmail::Subscription
no_subs = Strongmail.fetch_subscriptions(no_subs_member)                        # An empty Array
```

### Unsubscribe a Member from a List

