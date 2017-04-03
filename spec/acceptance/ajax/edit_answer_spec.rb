require 'acceptance_helper'

feature 'Edit answer', %q{
  In order to edit mistake
  As an authenticated user and author
  I want to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link Edit answer' do
      expect(page).to have_content 'Edit answer'
    end

    scenario 'edit his answer', js: true do
      click_on 'Edit answer'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save answer'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end
  end

  scenario 'Non-authenticated user try to edit answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Edit answer'
  end

  scenario 'Authenticated user try edit answer from other user' do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).not_to have_content 'Edit answer'
  end
end