class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    # This is needed to fetch the current_user object
    if has_role?
      session[:user_token] = auth_hash.fetch(:credentials).fetch(:token)

      redirect_to root_url
    else
      no_role
    end
  end

  def failure
    render plain: "Unable to be authenticated."
  end

  def no_role
    render plain: "You have access to this application, but have no roles."
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end

  def has_role?
    auth_hash.fetch(:info).fetch(:organisations).flat_map { |o| o.roles }.any?
  end
end
