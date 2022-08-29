module Voted
  extend ActiveSupport::Concern

  include VotedHelper

  included do
    before_action :set_votable, only: %i[upvote downvote]
  end

  def upvote
    render_json_with_errors(["You are the author of this #{@votable.class.name.downcase}"]) && return if current_user.author?(@votable)

    if @vote = Vote.find_by(votable: @votable, user: current_user)
      if @vote.liked?
        @votable.vote_cancel(@vote)
      else
        @votable.vote_vice_versa(@vote)
      end
    else
      @vote = create_vote_up
    end

    render_json_success_vote
  end

  def downvote
    render_json_with_errors(["You are the author of this #{@votable.class.name.downcase}"]) && return if current_user.author?(@votable)

    if @vote = Vote.find_by(votable: @votable, user: current_user)
      if @vote.disliked?
        @votable.vote_cancel(@vote)
      else
        @votable.vote_vice_versa(@vote)
      end
    else
      @vote = create_vote_down
    end
    
    render_json_success_vote
  end

  # TODO: need refactor
  def voted_resources(resource_type)
    voted_resources_hash = {}
    
    Vote.where(user: current_user, votable_type: resource_type).each do |vote|
      voted_resources_hash[vote.votable_id] = vote.liked
    end

    voted_resources_hash
  end

  private

  def create_vote_up
    @votable.rating_up!(1)
    @votable.votes.create(liked: true, user: current_user)    
  end

  def create_vote_down
    @votable.rating_down!(-1)
    @votable.votes.create(liked: false, user: current_user)    
  end

  def render_json_success_vote
    render json: {
      resource: @votable.class.name.downcase,
      id:       @votable.id,
      rating:   @votable.rating,
      liked:    @vote.persisted? ? @vote.liked.to_s : "destroyed"
    }
  end

  def render_json_with_errors(errors)
    render json: {
      errors: errors
    }, status: :unprocessable_entity
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end

