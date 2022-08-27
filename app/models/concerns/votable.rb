module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def change_rating_on!(value)
    update(rating: rating + value)
  end
end
