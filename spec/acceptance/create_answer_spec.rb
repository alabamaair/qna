require 'rails_helper'

feature 'Create answer' do

  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  scenario 'Authenticated user create the answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'Body'
    click_on 'Create answer'

    expect(page).to have_content 'Thanks for your answer!'
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)

    expect(page).to have_content 'For create answers you need to sign in or sign up before continuing.'
    expect(page).not_to have_content 'Create answer'
  end
end