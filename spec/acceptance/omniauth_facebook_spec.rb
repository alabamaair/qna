require 'acceptance_helper'

feature 'User can sign in with facebook' do
  let(:user) { create(:user) }

  scenario 'User login from facebook with valid credentials' do
    visit new_user_session_path
    mock_auth_hash('facebook', 'test@test.test')
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'You have to confirm your email address before continuing.'

    open_email 'test@test.test'
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed'

    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario 'Registred user can authenticate' do
    auth = mock_auth_hash('facebook', user.email)
    create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content('Successfully authenticated from Facebook account')
  end

  scenario 'User try login with facebook with invalid credentials' do
    visit new_user_session_path
    mock_auth_invalid_hash('facebook')
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Please enter your email to complete the login'
  end
end