require 'acceptance_helper'

feature 'Sign up' do

  scenario 'User try to sign up with correct data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    open_email 'user@example.com'
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'User try to sign up with incorrect data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: '1111'
    click_on 'Sign up'

    expect(page).to have_content 'prohibited this user from being saved'
  end
end