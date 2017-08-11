require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  let(:users) { create_list(:user, 2) }
  let(:questions) { create_list(:question, 2, created_at: Time.current - 1.hour) }
  let(:mail) { DailyMailer.digest(users.first).deliver_now }

  it 'renders the subject' do
    expect(mail.subject).to eq('Daily digest of questions')
  end

  it 'renders the receiver email' do
    expect(mail.to.join(' ')).to eq(users.first.email)
  end

  it 'have link to question' do
    questions.each do |question|
      expect(mail).to have_link question.title
    end
  end
end
