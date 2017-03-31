require 'acceptance_helper'

feature 'To mark best answer', %q{
  In order to mark best answer for my question
  As an authenticated user
  I want to be able to choice answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user and author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees checkbox for choice' do
      find(:css, "#best_answer")
      #expect(page).to have_content 'Best answer'
    end

    scenario 'choice answer as best', js: true do
      find(:css, "#best_answer").set(true)
      within '.answers' do
        expect(page).to have_selector 'best-answer'
      end
    end
  end

  scenario 'Non-authenticated user try to mark best answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Best answer'
  end
end