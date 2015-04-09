# Omniauth::Dsds

This gem contains the DSDS strategy for OmniAuth.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-dsds'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-dsds

## Usage

### Register provider

Tell OmniAuth about this provider. For a Rails app, your
`config/initializers/omniauth.rb` file should look like this:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :defence_request, API_KEY, API_SECRET
end
```

Replace `"API_KEY"` and `"API_SECRET"` with appropriate values.

### Controller mix-ins

Include the module in any controller:
```ruby
include Omniauth::Dsds::ControllerMethods
```

This will give access to a `current_user` method, which returns a User
object representing the currently logged in user.

It also provides a Devise-like `authenticate_user!` method, which redirects
to the login workflow for the Authentication application.

## Contributing

1. Fork it (https://github.com/[my-github-username]/omniauth-dsds/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
