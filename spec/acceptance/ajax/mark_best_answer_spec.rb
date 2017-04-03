require 'acceptance_helper'

feature 'To mark best answer', %q{
  In order to mark best answer for my question
  As an authenticated user
  I want to be able to choice answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }
  given(:user2) { create(:user) }

  describe 'Authenticated user and author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'mark answer as best', js: true do
      first(:button, 'Mark as best').click
      within '.best-answer' do
        expect(page).to have_content '=== Best answer ==='
        expect(page).not_to have_content 'Mark as best'
      end
    end

    scenario 'mark other answer as best and answer move on top page', js: true do
      within "#container-answer-#{answer2.id}" do
        click_on 'Mark as best'
        expect(page).to have_content '=== Best answer ==='
      end
      within "#container-answer-#{answer.id}" do
        expect(page).not_to have_content '=== Best answer ==='
      end

      expect(find("li.answer-body", match: :first)).to have_content answer2.body
    end
  end

  scenario 'Authenticated user as non-author try to mark best answer' do
    sign_in(user2)
    visit question_path(question)

    expect(page).not_to have_content 'Mark as best'
  end

  scenario 'Non-authenticated user try to mark best answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Mark as best'
  end
end