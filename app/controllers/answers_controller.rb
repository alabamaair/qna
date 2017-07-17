# frozen_string_literal: true
class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :load_answer, only: [:update, :destroy]
  after_action :publish_answer, only: [:create]

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

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("/questions/#{@question.id}/answers",
                                 answer: @answer,
                                 rating: @answer.rating,
                                 attachments: @answer.attachments.as_json(methods: :with_meta),
                                 question_user_id: @question.user_id,
                                 method: 'publish')
  end
end
