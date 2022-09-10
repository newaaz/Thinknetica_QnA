class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:question_id]}_and_answers_comments"
  end
end
