module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    alias_method :rating_up!, :change_rating_on!
    alias_method :rating_down!, :change_rating_on!
  end

  def vote_cancel(vote)  
    vote.liked? ? self.rating_down!(-1) : self.rating_up!(1)

    vote.destroy  
  end

  def vote_vice_versa(vote)
    if vote.liked?
      vote.update(liked: false)

      self.rating_down!(-2)    
    else
      vote.update(liked: true)

      self.rating_up!(2)    
    end
  end


  def change_rating_on!(value)
    update(rating: rating + value)
  end

end
