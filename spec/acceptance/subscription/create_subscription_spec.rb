require 'acceptance_helper'

feature 'Create subscription for question' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question){ create(:question, user: author) }

  context 'non authenticated user' do
    scenario 'can\'t subscribe the question' do
      visit question_path(question)
      within '.question-container' do
        expect(page).to_not have_link 'Subscribe'
      end
    end
  end

  context 'authenticated user' do
    scenario 'can create subscriptions for question', js: true do
      sign_in user
      visit question_path(question)
      within '.question-container' do
        expect(page).to have_link 'Subscribe'

        click_on 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end
  end

  context 'with subscribed user', js: true do
    scenario 'send email for subscribed user after create answer' do
      sign_in user
      visit question_path(question)
      fill_in 'Body', with: 'Body answer'
      click_on 'Create answer'
      sleep 1

      open_email(author.email)
      expect(current_email).to have_content 'Body answer'
    end
  end
end
