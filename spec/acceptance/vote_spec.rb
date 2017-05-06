require 'acceptance_helper'

feature 'To vote for questions and answers', %q{
  In order to express my opinion
  As an authenticated user
  I want to be able to vote for questions and answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:user2) { create(:user) }

  describe 'Authenticated user and non-author' do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'try to raise rating for question', js: true do
      within "#question_container#{question.id}" do
        click_on 'Vote up'

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content 'Unvote'
        expect(page).not_to have_content 'Vote up'
        expect(page).not_to have_content 'Vote down'
      end
    end

    scenario 'try to lower rating for question', js: true do
      within "#question_container#{question.id}" do
        click_on 'Vote down'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'Unvote'
        expect(page).not_to have_content 'Vote up'
        expect(page).not_to have_content 'Vote down'
      end
    end

    scenario 'try to unvote for question', js: true do
      within "#question_container#{question.id}" do
        click_on 'Vote down'
        click_on 'Unvote'

        expect(page).to have_content 'Rating: 0'
        expect(page).not_to have_content 'Unvote'
        expect(page).to have_content 'Vote up'
        expect(page).to have_content 'Vote down'
      end
    end

    scenario 'try to raise rating for answer', js: true do
      within "#container-answer-#{answer.id}" do
        click_on 'Vote up'

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_content 'Unvote'
        expect(page).not_to have_content 'Vote up'
        expect(page).not_to have_content 'Vote down'
      end
    end

    scenario 'try to lower rating for answer', js: true do
      within "#container-answer-#{answer.id}" do
        click_on 'Vote down'

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_content 'Unvote'
        expect(page).not_to have_content 'Vote up'
        expect(page).not_to have_content 'Vote down'
      end
    end

    scenario 'try to unvote for answer', js: true do
      within "#container-answer-#{answer.id}" do
        click_on 'Vote down'
        click_on 'Unvote'

        expect(page).to have_content 'Rating: 0'
        expect(page).not_to have_content 'Unvote'
        expect(page).to have_content 'Vote up'
        expect(page).to have_content 'Vote down'
      end
    end
  end

  scenario 'Authenticated user and author try to change rating' do
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_content 'Vote up'
    expect(page).not_to have_content 'Vote down'
    expect(page).not_to have_content 'Unvote'
  end

  scenario 'Non-authenticated user try to change rating' do
    visit question_path(question)

    expect(page).not_to have_content 'Vote up'
    expect(page).not_to have_content 'Vote down'
    expect(page).not_to have_content 'Unvote'
  end
end