require 'acceptance_helper'

feature 'User can sign in with providers' do
  let(:user) { create(:user) }

  context 'Sign in with Facebook' do
    scenario 'User login from facebook with valid credentials' do
      visit new_user_session_path
      mock_auth_hash('facebook', 'test@test.test')
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    scenario 'User try login with facebook with invalid credentials' do
      visit new_user_session_path
      mock_auth_invalid_hash('facebook')
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Could not authenticate you from Facebook'
    end
  end

  context 'Sign in with Twitter' do
    scenario 'User login from twitter with valid credentials' do
      visit new_user_session_path
      mock_auth_hash('twitter', 'test@test.test')
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    scenario 'User try login from twitter with invalid credentials' do
      visit new_user_session_path
      mock_auth_invalid_hash('twitter')
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Could not authenticate you from Twitter'
    end
  end
end
