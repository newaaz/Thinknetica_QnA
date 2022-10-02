class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index]
  before_action :set_answer, only: %i[show destroy update]

  def index
    answers = @question.answers
    render json: answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url, :_destroy])
  end
end
