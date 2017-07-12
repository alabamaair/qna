require 'acceptance_helper'

feature 'Add comments to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'create valid answer comment', js: true do
    within '.answer_comments' do
      click_on 'Add comment'
      fill_in "comment_text_#{answer.id}", with: 'Text comment'
      click_on 'Create Comment'

      expect(page).to have_content 'Text comment'
    end
  end

  scenario 'create invalid answer comment', js: true do
    within '.answer_comments' do
      click_on 'Add comment'
      click_on 'Create Comment'

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'mulitple sessions for answers comment' do
    scenario 'comments appears on another page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer_comments' do
          click_on 'Add comment'
          fill_in "comment_text_#{answer.id}", with: 'Text comment'
          click_on 'Create Comment'

          expect(page).to have_content 'Text comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answer_comments' do
          expect(page).to have_content 'Text comment'
        end
      end
    end
  end

  scenario 'create valid comment for question', js: true do
    within '.question_comments' do
      click_on 'Add comment'
      fill_in "comment_text_#{question.id}", with: 'Text comment'
      click_on 'Create Comment'

      expect(page).to have_content 'Text comment'
    end
  end

  scenario 'create invalid comment for question', js: true do
    within '.question_comments' do
      click_on 'Add comment'
      click_on 'Create Comment'

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'mulitple sessions for questions comment' do
    scenario 'comments appears on another page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question_comments' do
          click_on 'Add comment'
          fill_in "comment_text_#{question.id}", with: 'Text comment'
          click_on 'Create Comment'

          expect(page).to have_content 'Text comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question_comments' do
          expect(page).to have_content 'Text comment'
        end
      end
    end
  end
end