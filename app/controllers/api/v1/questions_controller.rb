class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  def index
    questions = Question.all
    render json: questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    authorize! :create, Question

    question = current_resource_owner.authored_questions.build(question_params)

    if question.save
      render json: question, serializer: QuestionSerializer
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @question

    if  @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question

    @question.destroy
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: [:name, :url, :_destroy],
                                     award_attributes: [:title, :image, :_destroy])
  end
end
