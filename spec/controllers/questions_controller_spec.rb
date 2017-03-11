# frozen_string_literal: true
require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #new' do
    before { get :new }

    it 'assigns new Question in @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
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
end
