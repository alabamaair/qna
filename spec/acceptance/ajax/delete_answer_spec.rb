require 'acceptance_helper'

feature 'Delete answer' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:user2) { create(:user) }

  scenario 'Authenticated user-author can delete the answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Destroy answer'

    expect(page).not_to have_content answer.body
  end

  scenario 'Authenticated user non-author try delete the answer', js: true do
    sign_in(user2)

    visit question_path(question)

    expect(page).not_to have_content 'Destroy answer'
  end

  scenario 'Non-authenticated user try to destroy answer', js: true do
    visit question_path(question)

    expect(page).not_to have_content 'Destroy'
  end
end