require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create :question }

  describe 'POST #create' do
    login_user
    subject { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }

    context 'with valid attributes' do
      it 'create answer in database' do
        expect { subject }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      subject do
        post :create,
             params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
      end

      it 'not create answer in DB' do
        expect { subject }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #update' do
    login_user

    let!(:answer) { create(:answer, question: question, user: @user) }
    let(:attr) { { body: 'new body' } }

    context 'with valid attributes' do
      subject { patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question.id, format: :js } }

      it 'assigns the requested answer to @answer' do
        subject
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns th question' do
        subject
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: attr, question_id: question.id, format: :js }
        answer.reload
        expect(answer.body).to eq attr[:body]
      end

      it 'render update template' do
        expect(subject).to render_template :update
      end
    end

    context 'with invalid attributes' do
      subject { patch :update, params: { id: answer, answer: { body: '' }, question_id: question.id, format: :js } }

      it 'not create question in DB' do
        expect { subject }.to_not change(Answer, :count)
      end
    end

    context 'with invalid user (non-author)' do
      login_user

      it 'not allow edit for non-author' do
        patch :update, params: { id: answer, answer: attr, question_id: question.id, format: :js }
        answer.reload
        expect(answer.body).not_to eq attr[:body]
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    let!(:answer) { create(:answer, question: question, user: @user) }

    subject { delete :destroy, params: { id: answer, question_id: question, format: :js } }

    it 'delete answer from database' do
      expect { subject }.to change(Answer, :count).by(-1)
    end

    context 'authenticated user non-author' do
      login_user

      subject { delete :destroy, params: { id: answer, question_id: question, format: :js } }

      it 'cannot delete answer' do
        expect { subject }.to_not change(Answer, :count)
      end

    end

  end
end
