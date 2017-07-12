require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'with authenticated user' do
      login_user

      it 'save new comments in the database with valid attributes' do
        expect { post :create, params: { commentable: 'question', question_id: question, comment: attributes_for(:comment), format: :js }}.to change(Comment, :count).by(1)
      end

      it 'can\'t save new comment in database with invalid attributes' do
        expect { post :create, params: { commentable: 'question', question_id: question, comment: attributes_for(:invalid_comment), format: :js }}.to_not change(Comment, :count)
      end
    end

    context 'with non-authenticated user' do
      it 'can\'t save new comment in database without login' do
        expect { post :create, params: { commentable: 'question', question_id: question, comment: attributes_for(:comment), format: :js }}.to_not change(Comment, :count)
      end
    end
  end


  describe 'DELETE #destroy' do

    context 'with author comments' do
      login_user
      let!(:comment){ create(:comment, user: @user) }

      it 'can delete comment' do
        expect { delete :destroy, params: { id: comment, format: :js }}.to change(Comment, :count).by(-1)
      end
    end

    context 'with authenticated user' do
      login_user
      let!(:comment) { create(:comment) }

      it 'can\'t delete comment' do
        expect { delete :destroy, params: { id: comment, format: :js }}.to_not change(Comment, :count)
      end
    end

    context 'without login' do
      let!(:comment){ create(:comment) }

      it 'can\'t delete comments' do
        expect { delete :destroy, params: { id: comment, format: :js }}.to_not change(Comment, :count)
      end
    end
  end
end