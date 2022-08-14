class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: %i[show edit update destroy set_best_answer]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @best_answer = @question.best_answer
    @answers = @question.answers.where.not(id: @question.best_answer_id).with_attached_files
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
      @answers = @question.answers.where.not(id: @question.best_answer_id)
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url, :_destroy],
                                     award_attributes: [:title, :image, :_destroy])
  end
end
