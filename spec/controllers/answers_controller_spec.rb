require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create :question }

  describe 'POST #create' do
    subject { post :create, params: { answer: attributes_for(:answer), question_id: question } }

    context 'with valid attributes' do
      it 'create answer in database' do
        expect { subject }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      subject do
        post :create,
             params: { answer: attributes_for(:invalid_answer), question_id: question }
      end

      it 'not create answer in DB' do
        expect { subject }.to_not change(question.answers, :count)
      end
    end
  end
end
