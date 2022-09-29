class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update]

  authorize_resource

  after_action  :publish_answer, only: :create

  def create
    @answer = @question.answers.create(answer_params.merge(author: current_user, question: @question))

    @voted_resources = voted_resources('Answer') # for the vouting
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question

    @voted_resources = voted_resources('Answer') # for the vouting
  end

  def destroy    
    @answer.destroy 
  end

  private

  def publish_answer
    return if @answer.errors.any?
  
    ActionCable.server.broadcast("question_#{@question.id}_answers", @answer.to_json(include: :links) )
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end
end
