require 'acceptance_helper'

feature 'Delete question' do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:user2) { create(:user) }

  scenario 'Authenticated user-author try delete the question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Destroy'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).not_to have_content question.body
  end

  scenario 'Authenticated user non-author try delete the question' do
    sign_in(user2)

    visit question_path(question)

    expect(page).not_to have_content 'Destroy'
  end

  scenario 'Non-authenticated user try to destroy answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Destroy'
  end
end