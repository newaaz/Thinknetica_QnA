class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[new create]

  def new
    @user = User.new
  end

  def create
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: params[:user][:email], password: password, password_confirmation: password)

    if @user.save
      confirm_email_for(@user)
    else
      render 'new'
    end    
  end

  def awards    
    @user = User.find(params[:id])
    @awards = @user.awards
  end

  private

  def confirm_email_for(user)
    user.oauth_providers.create(provider: session[:oauth_provider], uid:  session[:oauth_uid])

    session.delete %i[oauth_provider oauth_uid]

    user.send_confirmation_instructions
    flash[:alert] = 'You will receive an email with instructions for how to confirm your email address in a few minutes.'
    redirect_to root_path
  end
end


