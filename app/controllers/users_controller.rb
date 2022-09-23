class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[new create]

  def new
    @user = User.new
  end

  def create
    debugger
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: params[:user][:email],
                        password: password,
                        password_confirmation: password)

    user.oauth_providers.create(provider: session[:oauth_provider],
                                uid:  session[:oauth_uid])
    
    sign_in_and_redirect user
  end

  def awards    
    @user = User.find(params[:id])
    @awards = @user.awards
  end

  private


end


