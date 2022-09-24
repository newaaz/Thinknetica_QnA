module OmniAuthMacros
  OmniAuth.config.test_mode = true

  def mock_auth_hash(provider, email = nil)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
                                                                  'provider' => "#{provider}",
                                                                  'uid' => '123545',
                                                                  'info' => {
                                                                    'email' => email,
                                                                    'image' => 'mock_user_thumbnail_url'
                                                                  },
                                                                  'credentials' => {
                                                                    'token' => 'mock_token',
                                                                    'secret' => 'mock_secret'
                                                                  }
                                                                })
  end
end
