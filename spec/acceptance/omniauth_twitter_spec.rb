require 'acceptance_helper'

feature 'User can sign in with twitter' do
  let(:user) { create(:user) }

  scenario 'User login from twitter with valid credentials', js: true do
    visit new_user_session_path
    mock_auth_hash('twitter', nil)
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Please enter your email to complete the login'

    fill_in 'Email', with: 'twitter@test.test'
    click_on 'Submit'

    expect(page).to have_content 'You have to confirm your email address before continuing.'

    open_email 'twitter@test.test'
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed'

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'Registred user can authenticate' do
    auth = mock_auth_hash('twitter', user.email)
    create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    expect(page).to have_content('Successfully authenticated from Twitter account')
  end

  scenario 'User try login from twitter with invalid credentials' do
    visit new_user_session_path
    mock_auth_invalid_hash('twitter')
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Error authenticate with providers'
  end
end
