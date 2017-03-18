class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find params[:question_id]
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    @answer = Answer.find params[:id]
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer destroy successfully.'
    else
      flash[:alert] = 'You not an author.'
      redirect_to question_path(@answer.question)
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
