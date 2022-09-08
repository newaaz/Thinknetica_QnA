module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :create_comment
    after_action  :publish_comment, only: :create_comment
  end

  def create_comment
    @comment = @commentable.comments.new(body: params[:comment][:body], user: current_user)
    
    if @comment.save
      render_json_comment
    else
      render_json_with_errors(@comment.errors)
    end
  end

  def create_form
    debugger
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("question_#{set_question_id}_and_answers_comments", @comment.to_json )
  end

  def set_question_id
    @comment.commentable_type == 'Question' ? @commentable.id : @commentable.question.id
  end

  def render_json_comment
    render json: { comment: @comment }
  end

  def render_json_with_errors(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end
