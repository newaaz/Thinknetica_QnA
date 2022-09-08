module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :create_comment
    after_action  :publish_comment, only: :create_comment
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

  private

  def publish_comment
    return if @comment.errors.any?
    
    ActionCable.server.broadcast("question_#{@commentable.id}_and_answers_comments", @comment.to_json )
  end

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

