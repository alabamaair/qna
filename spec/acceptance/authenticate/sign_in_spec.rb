require 'rails_helper'

feature 'Sign in' do

  let(:user) { create(:user) }

  scenario 'Existing user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Non-existing user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: '111'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end