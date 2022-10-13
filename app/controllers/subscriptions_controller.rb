class SubscriptionsController < ApplicationController

  before_action :authenticate_user!
  authorize_resource

  def create
    question = Question.find(params[:question_id])

    redirect_to question, notice: 'You are already subscribed to this question' if current_user.subscribed_on?(question)

    question.subscribers << current_user
    redirect_to question, notice: 'You subscribed to this question'
  end

  def destroy
    current_user.subscriptions.find_by(question_id: params[:id]).destroy
    redirect_back fallback_location: root_path, notice: 'You unsubscribed from this question'
  end
end
