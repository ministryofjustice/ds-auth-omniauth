# Omniauth::Dsds

This gem contains the OmniAuth strategy to authenticate against the [DRS Authentication provider](https://github.com/ministryofjustice/defence-request-service-auth).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "omniauth-dsds", github: "ministryofjustice/defence-request-service-omniauth-dsds", tag: "v0.3.0"
```

And then execute:

    $ bundle

## Usage

### Register provider

Tell OmniAuth about this provider. For a Rails app, your
`config/initializers/omniauth.rb` file should look like this:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :defence_request, AUTH_KEY, AUTH_SECRET
end
```

Replace `AUTH_KEY` and `AUTH_SECRET` with appropriate values
from the authentication service provider.

You will need to set environment variables in order for the gem
to know where the authentication service resides, and where Omniauth
needs to redirect back to after authenticating. These should be set as
`ENV['AUTHENTICATION_SITE_URL']` and `ENV['AUTHENTICATION_REDIRECT_URI']`
respectively.

The user details endpoint on the authentication provider will default to
`/api/v1/me` but can be overridden by setting `ENV['AUTHENTICATION_RAW_INFO_PATH']`

### Controller mix-ins

Include the module in any controller:
```ruby
include Omniauth::Dsds::ControllerMethods
```

This will give access to a `current_user` method, which returns a User
object representing the currently logged in user.

It also provides a Devise-like `authenticate_user!` method, which redirects
to the login workflow for the Authentication application.

If the User does not have any roles for the application (as returned by the profile API response) then the session will be cleared and the User redirected to the login page.

Override the authentication_application_id and authentication_application_secret methods to customize where OAuth credentials are loaded from.

### Authorization
If the current_user does not have permission to access the application then the Authentication provider will redirect to `auth/failure?message=unauthorized` rather than the success route. See [https://github.com/intridea/omniauth/wiki](https://github.com/intridea/omniauth/wiki)

### Debugging
It can be handy to see exactly what requests are being made to the authentication provider.
Set `ENV['AUTH_DEBUG']` to enable debug logging.

## Contributing

1. Fork it (https://github.com/[my-github-username]/omniauth-dsds/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
