require "rails_helper"

RSpec.describe AnswerNotifierMailer, type: :mailer do
  let(:users){ create_list(:user, 2) }
  let(:question){ create(:question, user: users.first) }
  let(:answer) { create(:answer, user: users.last, question: question) }
  let(:mail) { AnswerNotifierMailer.answer_notify(users.first, answer).deliver_now }

  it 'renders subject' do
    expect(mail.subject).to eq("New answer create for #{question.title}")
  end

  it 'renders answer body' do
    expect(mail).to have_content answer.body
  end

  it 'renders the receiver email' do
    expect(mail.to.join(' ')).to eq(users.first.email)
  end
end
