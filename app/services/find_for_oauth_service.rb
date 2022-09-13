class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    oauth_provider = OauthProvider.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return oauth_provider.user if oauth_provider

    email = auth.info[:email]

    if user = User.find_by(email: email)
      user.create_oauth_provider(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_oauth_provider(auth)
    end    
    user
  end
end
