class User < ApplicationRecord
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          :confirmable,
          :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many  :authored_questions, foreign_key: "author_id", class_name: "Question", inverse_of: :author, dependent: :destroy
  has_many  :authored_answers, foreign_key: "author_id", class_name: "Answer", inverse_of: :author, dependent: :destroy
  has_many  :awards
  has_many  :votes, dependent: :destroy
  has_many  :comments, dependent: :destroy
  has_many  :oauth_providers, dependent: :destroy
  has_many  :subscriptions
  has_many  :subscribed_questions, through: :subscriptions, source: :question, dependent: :destroy

  def author?(resource)
    self == resource.author
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_oauth_provider(auth)
    oauth_providers.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed_on?(question)
    subscribed_questions.include?(question)
  end
end
