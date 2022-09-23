class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github  
    sign_in_with_provider
  end

  def vkontakte
    sign_in_with_provider
  end

  private

  def sign_in_with_provider
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      redirect_unconfirmed_user unless @user.confirmed?

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{action_name.capitalize}") if is_navigational_format?
    else
 
      redirect_to new_user_path

      session[:oauth_provider] = request.env['omniauth.auth']['provider']
      session[:oauth_uid] = request.env['omniauth.auth']['uid']
         
    end 
  
  end

  def redirect_unconfirmed_user
    # set_flash_message(:notice, :success, kind: "#{action_name.capitalize}")
    flash[:alert] = 'You have to confirm your email address before continuing.'
    redirect_to new_user_session_path
  end


end
