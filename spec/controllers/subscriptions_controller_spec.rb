require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  login_user

  describe '#POST' do
    let!(:question){ create(:question) }

    subject { post :create, params: { question_id: question, format: :js } }

    it 'create new subscription' do
      expect { subject }.to change(Subscription, :count).by(1)
    end

    it 'render create template' do
      subject
      expect(response).to render_template :create
    end
  end

  describe '#DELETE' do
    let!(:subscription) { create(:subscription, user: @user) }

    subject { delete :destroy, params: { id: subscription.id, format: :js } }

    it 'destroy subscription' do
      expect { subject }.to change(Subscription, :count).by(-1)
    end

    it 'renders delete template' do
      subject
      expect(response).to render_template :destroy
    end
  end
end
