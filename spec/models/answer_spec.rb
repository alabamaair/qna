require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }

  it { should have_many(:attachments) }

  it { should accept_nested_attributes_for :attachments }

  it { should have_many(:comments).dependent(:destroy) }

  describe 'Notification author question after create answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer){ build :answer, question: question }

    it 'run notification job after answer create' do
      expect(AnswersNotifierJob).to receive(:perform_later)
      answer.save!
    end

    it 'don\'t run notification job after answer update' do
      answer.save!

      expect(AnswersNotifierJob).to_not receive(:perform_later)
      answer.update!(body: 'answer new body')
    end
  end
end
