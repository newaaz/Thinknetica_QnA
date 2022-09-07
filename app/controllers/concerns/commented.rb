module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :create_comment
  end

  def create_comment
    #debugger

    @comment = @commentable.comments.new(body: params[:comment][:body], user: current_user)
    
    if @comment.save
      render_json_comment
    else
      render_json_with_errors(@comment.errors)
    end

  end

  def upvote
    render_json_with_errors(["You are the author of this"]) if current_user.id == 'no_matter'

    if @vote = Vote.find_by(votable: @votable, user: current_user)
      @vote = create_vote_up
    end

    render_json_comment
  end

  private

  def render_json_comment
    render json: {
      comment:  @comment,
      resource: @commentable.class.name.downcase,
      id:       @commentable.id
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

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end

