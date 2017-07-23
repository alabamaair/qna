require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'facebook' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:facebook, nil)
    end

    context 'new user' do
      before { get :facebook }

      it 'render enter_email' do
        expect(response).to render_template 'omniauth_callbacks/enter_email'
      end

      it 'doesnt login' do
        expect(controller.current_user).to eq nil
      end
    end

    context 'exist user authenticate' do
      before do
        auth = mock_auth_hash(:facebook, user.email)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :facebook
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'login' do
        expect(controller.current_user).to eq user
      end
    end
  end

  describe 'twitter' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:twitter, nil)
    end

    context 'new user' do
      before { get :twitter }

      it 'render enter_email' do
        expect(response).to render_template 'omniauth_callbacks/enter_email'
      end

      it 'doesnt login' do
        expect(controller.current_user).to eq nil
      end
    end

    context 'exist user authenticate' do
      before do
        auth = mock_auth_hash(:twitter, user.email)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :twitter
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'doesnt create user' do
        expect(controller.current_user).to eq user
      end
    end
  end
end
