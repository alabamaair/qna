require 'acceptance_helper'

feature 'Create answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'Body answer'
    click_on 'Create answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Body answer'
    end
  end

  scenario 'Authenticated user create the invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Create answer'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user try to create answer', js: true do
    visit question_path(question)

    expect(page).to have_content 'For create answers you need to sign in or sign up before continuing.'
    expect(page).not_to have_content 'Create answer'
  end

  context 'Multiple sessions' do
    scenario 'Answer appears for two users', js: true do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        fill_in 'Body', with: 'Body answer'
        click_on 'Create answer'

        within '.answers' do
          expect(page).to have_content 'Body answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Body answer'
      end
    end
  end
end
