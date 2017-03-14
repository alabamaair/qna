class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find params[:question_id]
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @question, notice: 'Thanks for your answer!'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
