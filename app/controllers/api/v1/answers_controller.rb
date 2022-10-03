class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show destroy update]

  def index
    answers = @question.answers
    render json: answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    authorize! :create, Answer

    answer = @question.answers.new(answer_params.merge(author: current_resource_owner))

    if answer.save
      render json: answer, serializer: AnswerSerializer
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @answer

    if  @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer

    @answer.destroy
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
