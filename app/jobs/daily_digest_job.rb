class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    return unless Question.in_digest.present?

    User.find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
