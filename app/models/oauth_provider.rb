class OauthProvider < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true
  validates :provider, uniqueness: { scope: :uid, message: "Provider already exists for this uid." }
end
