# frozen_string_literal: true
class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy, :mark_best_answer]
  after_action :publish_question, only: [:create]

  respond_to :js, only: [:update, :mark_best_answer]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def update
    respond_with @question.update(question_params) if current_user.author?(@question)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def destroy
    respond_with @question.destroy if current_user.author?(@question)
  end

  def mark_best_answer
    @answer = Answer.find params[:answer_id]
    respond_with(@answer.mark_best) if current_user.author?(@question)
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
