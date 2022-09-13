class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many  :authored_questions, foreign_key: "author_id", class_name: "Question", inverse_of: :author, dependent: :destroy
  has_many  :authored_answers, foreign_key: "author_id", class_name: "Answer", inverse_of: :author, dependent: :destroy
  has_many  :awards
  has_many  :votes, dependent: :destroy
  has_many  :comments, dependent: :destroy
  has_many  :oauth_providers, dependent: :destroy

  def author?(resource)
    self == resource.author
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_oauth_provider(auth)
    oauth_providers.create(provider: auth.provider, uid: auth.uid)
  end
end
