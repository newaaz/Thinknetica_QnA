class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: :destroy

  def create
    @answer = Answer.new(answer_params.merge(author: current_user, question: @question))
    if @answer.save
      redirect_to question_path(params[:question_id]), notice: "Your answer successfully added"
    else
      @answers = @question.answers
      render 'questions/show'    
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer was deleted'
    else
      flash[:alert] = 'This is not your answer'
      redirect_back(fallback_location: root_path)      
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
