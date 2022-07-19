class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_question
  
  def create
    @answer = @question.answers.build(answer_params)
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

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
