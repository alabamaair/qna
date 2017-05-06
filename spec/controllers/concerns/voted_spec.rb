require 'rails_helper'

RSpec.shared_examples 'voted' do
  resource = described_class.controller_name.singularize.to_sym
  let!(:votable) { create(resource) }
  let(:users_votable) { create(resource, user: @user) }
  login_user

  describe 'POST #vote_up' do
    subject(:vote_up) { post :vote_up, params: { id: votable.id }, format: :json }
    login_user

    it 'assigns resource to @votable' do
      vote_up
      expect(assigns(:votable)).to eq votable
    end

    it 'change rating to 1' do
      expect { vote_up }.to change { votable.rating }.by(1)
    end

    it 'renders json and status 200' do
      vote_up
      expect(response.headers['Content-Type']).to match /json/
      expect(response.status).to eq(200)
    end

    context 'User is author' do
      subject(:vote_up_invalid) { post :vote_up, params: { id: users_votable.id }, format: :json }

      it 'vote up don\'t changes rating' do
        expect { vote_up_invalid }.not_to change { votable.rating }
      end

      it 'renders json, status 422 and error text' do
        vote_up_invalid
        expect(response.headers['Content-Type']).to match /json/
        expect(response.status).to eq(422)
        expect(response.body).to eq('Sorry, it is not possible, sir, you\'re author.')
      end
    end
  end

  describe 'POST #vote_down' do
    login_user

    subject(:vote_down) { post :vote_down, params: { id: votable.id }, format: :json }

    it 'assigns resource to @votable' do
      vote_down
      expect(assigns(:votable)).to eq votable
    end

    it 'change rating to 1' do
      expect { vote_down }.to change { votable.rating }.by(-1)
    end

    it 'renders json and status 200' do
      vote_down
      expect(response.headers['Content-Type']).to match /json/
      expect(response.status).to eq(200)
    end

    context 'User is author' do
      subject(:vote_down_invalid) { post :vote_down, params: { id: users_votable.id }, format: :json }

      it 'vote down don\'t changes rating' do
        expect { vote_down_invalid }.not_to change { votable.rating }
      end

      it 'renders json, status 422 and error text' do
        vote_down_invalid
        expect(response.headers['Content-Type']).to match /json/
        expect(response.status).to eq(422)
        expect(response.body).to eq('Sorry, it is not possible, sir, you\'re author.')
      end
    end
  end

  describe 'DELETE #unvote' do
    subject(:unvote) do
      post :vote_up, params: { id: votable.id }, format: :json
      delete :unvote, params: { id: votable.id }, format: :json
    end
    login_user

    it 'delete vote' do
      unvote
      expect(votable.rating).to eq 0
    end

    it 'render json and status 200' do
      unvote
      expect(response.headers['Content-Type']).to match /json/
      expect(response.status).to eq(200)
    end
  end
end
