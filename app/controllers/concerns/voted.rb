module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote]
  end

  def upvote

    if @vote = Vote.find_by(user: current_user, votable: @votable)
      if @vote.liked?
        @vote.destroy
        @votable.rating_down!(1)
      else
        @vote.update(liked: true)
        @votable.rating_up!(2)
      end
    else
      @votable.votes.create(liked: true, user: current_user)
      @votable.rating_up!(1)
    end

    redirect_to root_path
  end

  def downvote
    if @vote = Vote.find_by(user: current_user, votable: @votable)
      if @vote.liked?
        @vote.update(liked: false)
        @votable.rating_down!(2)
      else
        @vote.destroy
        @votable.rating_up!(1)
      end
    else
      @votable.votes.create(liked: false, user: current_user)
      @votable.rating_down!(1)
    end    

    # render js: "console.log('#{@votable.title}')"

    redirect_to root_path
  end

  def voted_resources(resource_type)
    voted_resources_hash = {}
    
    Vote.where(user: current_user, votable_type: resource_type).each do |vote|
      voted_resources_hash[vote.votable_id] = vote.liked
    end

    voted_resources_hash
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

end

