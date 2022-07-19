class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  
  def create
    @answer = @question.answers.build(answer_params.merge(author: current_user))
    if @answer.save
      redirect_to question_path(params[:question_id]), notice: "Your answer successfully added"
    else
      @answers = @question.answers
      render 'questions/show'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
