class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    oauth_provider = OauthProvider.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return oauth_provider.user if oauth_provider
    
    if email = auth.info[:email]
      find_or_create_user_by_email(email)
    else
      User.new
    end    

  end

  private

  def find_or_create_user_by_email(email)
    if user = User.find_by(email: email)
      user.create_oauth_provider(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.now)
      user.create_oauth_provider(auth)
      #user.confirm
    end   

    user
  end
end
