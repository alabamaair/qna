class AnswerNotifierMailer < ApplicationMailer
  def answer_notify(user, answer)
    @answer = answer

    mail to: user.email,
         subject: "New answer create for #{answer.question.title}"
  end
end
