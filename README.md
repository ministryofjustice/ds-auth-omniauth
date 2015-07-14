# Ds::Omniauth

This gem contains the OmniAuth strategy to authenticate against the [MoJ Digital SSO provider](https://github.com/ministryofjustice/ds-auth).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ds-auth-omniauth", github: "ministryofjustice/ds-auth-omniauth", tag: "v0.9.0"
```

And then execute:

    $ bundle

## Usage

### Register provider

Tell OmniAuth about this provider. For a Rails app, your
`config/initializers/omniauth.rb` file should look like this:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ds_auth, AUTH_KEY, AUTH_SECRET
end
```

Replace `AUTH_KEY` and `AUTH_SECRET` with appropriate OAuth values
from the authentication service provider.

You will need to set environment variables in order for the gem
to know where the authentication service resides, and where Omniauth
needs to redirect back to after authenticating. These should be set as
`ENV['DS_AUTH_SITE_URL']` and `ENV['DS_AUTH_REDIRECT_URI']`
respectively.

The user details endpoint on the authentication provider will default to
`/api/v1/me` but can be overridden by setting `ENV['DS_AUTH_RAW_INFO_PATH']`

### Basic Setup
The below steps will get you up and running with a basic setup that will authenticate the entire application.

A current_user method is available to return a User object that is fetched on every request.

Include the helper module and before_action in your ApplicationController:

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Omniauth::Dsds::ControllerMethods
  before_action :authenticate_user!

  # other controller stuff ...
end
```

Set up the relevant routes:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  # other routes ...
end
```

Implement a Sessions Controller:

```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    # This is needed to fetch the current_user object
    session[:user_token] = auth_hash.fetch(:credentials).fetch(:token)

    redirect_to root_url
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
```

### Storing Current User Locally

The Omniauth::Dsds::ControllerMethods mixin will also give access to a `current_user` method, which returns a User
object representing the currently logged in user. This will return a DsAuth::Omniauth::User instance.

This relies on the session containing the user_token (see above). The current_user will be fetched on every request.

If you want to store the current_user object locally and not fetch it every request, or do something different then find the User, store its id in the session and override the ```current_user``` method in your ApplicationController:

```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)

    session[:user_id] = @user.id

    redirect_to root_url
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Omniauth::Dsds::ControllerMethods
  before_action :authenticate_user!

  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end

  # other controller stuff ...
end

```

Here is the format of the ```request.env['omniauth.auth']``` hash:

```ruby
{
  "provider"=>"ds_auth",
  "uid"=>"4d663e19-8e63-4cd0-800d-dabdc3f51fe5",
  "info"=>{},
  "credentials"=>{
    "token"=>"41f7784aa87373426d0990cf8ed97203a0c20856bf83a77ca62fcbe302377710",
    "expires_at"=>1436871976,
    "expires"=>true
  },
  "extra"=>{}
}
```

Notes:

* uid is the unique identifer for the current user


### Authorization
If the User does not have any roles for the application (as returned by the profile API response) then the session will be cleared and the User redirected to the authentication error page.

Likewise if configured in the Auth App if current_user does not have permission to access the application then the Authentication provider will redirect to `auth/failure?message=unauthorized` rather than the sessions#create route. See [https://github.com/intridea/omniauth/wiki](https://github.com/intridea/omniauth/wiki)

### Debugging
It can be handy to see exactly what requests are being made to the authentication provider.
Set `ENV['DS_AUTH_DEBUG']` to enable debug logging.

### Customizing
App ID and App Secrets can be customized by overriding these methods in your ApplicationController:

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # other controller stuff ...

  protected

  def authentication_application_id
   # custom app_id
  end

  def authentication_application_secret
    # custom app_secret
  end
end
```

## Contributing

1. Fork it (https://github.com/[my-github-username]/ds-auth-omniauth/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
