require 'acceptance_helper'

feature 'Delete subscriptions with question' do
  given(:user) { create(:user) }
  given(:question){ create(:question) }

  context 'non authenticated user' do
    scenario 'can\'t unsubscribe the question' do
      visit question_path(question)
      within '.question-container' do
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end

  context 'with user subscribe question' do
    given!(:subscription){ create(:subscription, question: question, user: user) }

    scenario 'can unsubscribe question', js: true do
      sign_in user
      visit question_path(question)
      within '.question-container' do
        expect(page).to have_link 'Unsubscribe'
        click_on 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end
  end

  context 'with user non subscribe question' do
    scenario 'can\'t unsubscribe the question' do
      sign_in user
      visit question_path(question)
      within '.question-container' do
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end
end