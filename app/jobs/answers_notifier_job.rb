class AnswersNotifierJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      AnswerNotifierMailer.answer_notify(subscription.user, answer).deliver_later unless answer.user_id == subscription.user_id
    end
  end
end
