class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  def disliked?
    !liked?
  end
end
