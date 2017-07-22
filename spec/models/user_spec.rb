require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe '.from_omniauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'return user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.from_omniauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email } ) }

        it 'does not create user' do
          expect { User.from_omniauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.from_omniauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.from_omniauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return the user' do
          expect(User.from_omniauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'newuser@email.com' } ) }

        it 'create new user' do
          expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
        end

        it 'return new user' do
          expect(User.from_omniauth(auth)).to be_a(User)
        end

        it 'fill email for new user' do
          user = User.from_omniauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'create authorization for user' do
          user = User.from_omniauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'create authorization with correct uid and provider' do
          authorization = User.from_omniauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end

  end
end
