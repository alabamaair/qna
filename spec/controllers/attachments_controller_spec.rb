# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    login_user

    let(:question) { create(:question, user: @user) }
    let!(:attachment) {create(:attachment, attachable: question) }

    subject { delete :destroy, params: { id: attachment, format: :js } }

    it 'delete attachment from database' do
      expect { subject }.to change(question.attachments, :count).by(-1)
    end

    context 'authenticated user non-author' do
      login_user

      subject { delete :destroy, params: { id: attachment, format: :js } }

      it 'cannot delete attachment' do
        expect { subject }.to_not change(Attachment, :count)
      end
    end
  end
end
