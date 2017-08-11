require 'rails_helper'

RSpec.describe AnswersNotifierJob, type: :job do
  include ActiveJob::TestHelper

  let!(:question){ create(:question) }
  let!(:subscription){ create_list(:subscription, 2, question: question) }
  let!(:answer){ create(:answer, question: question) }

  it 'sends answer notify with subscription user' do
    answer.question.subscriptions.each do |subscription|
      expect(AnswerNotifierMailer).to receive(:answer_notify).with(subscription.user, answer).and_call_original
    end
    AnswersNotifierJob.perform_now(answer)
  end
end
