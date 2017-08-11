class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.in_digest

    mail to: user.email,
         subject: 'Daily digest of questions'
  end
end
