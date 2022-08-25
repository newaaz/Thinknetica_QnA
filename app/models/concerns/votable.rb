module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end  

  def rating_up!(value)
    update(rating: rating + value)
  end

  def rating_down!(value)
    update(rating: rating - value)
  end

end

