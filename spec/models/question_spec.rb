require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }

  it { should accept_nested_attributes_for :attachments }

  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '#subscribe_author' do
    let(:user) { create (:user) }
    let(:question) { build(:question, user: user) }

    it 'perform after question has been created' do
      expect(question).to receive(:subscribe_author)
      question.save
    end

    it 'subscribe author question after create' do
      expect { question.save }.to change(user.subscriptions, :count).by(1)
    end
  end
end
