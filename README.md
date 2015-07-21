# Ds::Omniauth

This gem contains the OmniAuth strategy to authenticate against the [MoJ Digital SSO provider](https://github.com/ministryofjustice/ds-auth).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ds-auth-omniauth", github: "ministryofjustice/ds-auth-omniauth", tag: "v0.10.0"
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
  include DsAuth::Omniauth::ControllerMethods
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

The DsAuth::Omniauth::ControllerMethods mixin will also give access to a `current_user` method, which returns a User
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
  include DsAuth::Omniauth::ControllerMethods
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
  "info"=>{
    "name" => "Bob Smith",
    "email" => "bob@example.com",
    "phone" => "02071234567",
    "mobile" => "071234567",
    "full_address" => "1 Fake Steet",
    "postcode" => "AB1 2CD",
    "organisations" => [
      {
        "uid" => "b2e402e4-6e44-485b-87b8-b47343cfbedb",
        "name" => "Bobs Company",
        "roles" => ["admin", "viewer"]
      }
    ]
  },
  "credentials"=>{
    "token"=>"41f7784aa87373426d0990cf8ed97203a0c20856bf83a77ca62fcbe302377710",
    "expires_at"=>1436871976,
    "expires"=>true
  },
  "extra"=>{}
}
```

Notes:

* *uid* is the unique identifer for the current user
* *organisations* is the list of organisations this user belongs to, with the roles that user has within *that* organisation
* a User may belong to multiple organisations, with multiple roles in each


### Authorization
The User object will be returned regardless of whether they have access
to the application. It is up to the consuming app to decide how this
should be handled.

For example, in the simple case of checking if the user has any role:

```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    # This is needed to fetch the current_user object
    if has_role?
      session[:user_token] = auth_hash.fetch(:credentials).fetch(:token)

      redirect_to root_url
    else
      # redirect to some unauthorized route
    end
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end

  def has_role?
    auth_hash.fetch(:info).fetch(:organisations).flat_map { |o| o.roles }.any?
  end
end
```

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
