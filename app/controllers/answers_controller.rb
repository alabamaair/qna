class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :load_answer, only: [:update, :destroy]

  def new
    @answer = Answer.new
    @answer.attachments.build
  end

  def create
    @question = Question.find params[:question_id]
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_answer
    @answer = Answer.find params[:id]
  end
end
