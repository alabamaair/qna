require 'rails_helper'

feature 'Create question', %q{
  In order to get answers
  As an authenticated user
  I want to be able to ask the question
} do

  let(:user) { create(:user) }

  scenario 'Authenticated user create the question' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask question'
    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Body'
  end

  scenario 'Authenticated user create the invalid question' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask question'
    fill_in 'Title', with: 'Title'
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
    expect(page).to have_content 'Errors'
  end

  scenario 'Non-authenticated user try to create question' do
    visit '/questions'
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end