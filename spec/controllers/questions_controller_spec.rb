# frozen_string_literal: true
require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #new' do
    login_user

    before { get :new }

    it 'assigns new Question in @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    login_user

    subject { post :create, params: { question: attributes_for(:question) } }

    context 'with valid attributes' do
      it 'create question in database' do
        expect { subject }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        expect(subject).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      subject { post :create, params: { question: attributes_for(:invalid_question) } }

      it 'not create question in DB' do
        expect { subject }.to_not change(Question, :count)
      end

      it 'render new view' do
        expect(subject).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    login_user

    let!(:question) { create(:question, user: @user) }
    let(:attr) { { body: 'new question body' } }

    context 'with valid attributes' do
      subject { patch :update, params: { id: question, question: attributes_for(:question), format: :js } }

      it 'assigns the requested question to @question' do
        subject
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: attr, format: :js }
        question.reload
        expect(question.body).to eq attr[:body]
      end

      it 'render update template' do
        expect(subject).to render_template :update
      end
    end

    context 'with invalid attributes' do
      subject { patch :update, params: { id: question, question: { title: '', body: '' }, format: :js } }

      it 'not save question in DB' do
        expect { subject }.to_not change(Question, :count)
      end

      it 'not change question attributes' do
        subject
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 're-renders edit view' do
        expect(subject).to render_template :update
      end
    end

    context 'with invalid user (non-author)' do
      login_user

      it 'not allow edit for non-author' do
        patch :update, params: { id: question, question: attr, format: :js }
        question.reload
        expect(question.body).not_to eq attr[:body]
      end
    end
  end


  describe 'PUT #mark_best_answer' do
    login_user

    let!(:question) { create(:question, user: @user) }
    let!(:answer) { create(:answer, user: @user, question: question) }
    let(:answer2) { create(:answer, user: @user, question: question) }

    before { put :mark_best_answer, params: { id: question, answer_id: answer, format: :js } }

    context 'with valid user' do
      it 'assigns the requested question to @question and answer to @answer' do
        expect(assigns(:question)).to eq question
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attribute' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render mark template' do
        expect(response).to render_template :mark_best_answer
      end
    end

    context 'with invalid user' do
      login_user

      it 'not save answer attribute' do
        put :mark_best_answer, params: { id: question, answer_id: answer2, format: :js }
        answer.reload
        expect(answer2.best).to eq false
      end
    end
  end
end
