# frozen_string_literal: true
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy, :mark_best_answer]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
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
    @answer = Answer.new
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
    @answer = Answer.find params[:answer_id]
    if params[:best]
      @question.unchecked_answers
      @answer.update_attribute(:best, params[:best])
      @question.update_attribute(:best_answer, @answer)
    else
      @question.update_attribute(:best_answer, nil)
    end
  end

  private

  def load_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
