# frozen_string_literal: true
class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy, :mark_best_answer]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question destroy successfully.'
    else
      flash.now[:alert] = 'You not an author.'
      render :show
    end
  end

  def mark_best_answer
    if current_user.author?(@question)
      @answer = Answer.find params[:answer_id]
      @answer.mark_best
    end
  end

  private

  def load_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      question: ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
