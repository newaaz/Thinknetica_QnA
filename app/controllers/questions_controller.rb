class QuestionsController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: %i[show edit update destroy set_best_answer]

  after_action  :publish_question, only: :create

  def index
    @questions = Question.all.order(:id)    
    
    @voted_resources = voted_resources('Question') if current_user # vouting for questions
  end

  def show
    @answer = Answer.new
    @comment = Comment.new
    @answer.links.new
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @question.best_answer_id).with_attached_files

    @voted_resources = voted_resources('Answer') if current_user # vouting for answers

    gon.question_id = @question.id    
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_award
  end

  def create
    @question = current_user.authored_questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question was deleted'
    else
      flash[:alert] = 'This is not your question'
      redirect_back(fallback_location: root_path)      
    end
  end

  def set_best_answer
    if current_user.author?(@question)
      @best_answer = Answer.find(params[:best_answer_id])
      @question.update(best_answer: @best_answer)
      
      @question.award.update(user: @best_answer.author) if @question.award.present?    

      @answers = @question.answers.where.not(id: @question.best_answer_id)

      @voted_resources = voted_resources('Answer') # vouting for answers
    end
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(:questions, @question.to_json)
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url, :_destroy],
                                     award_attributes: [:title, :image, :_destroy])
  end
end
