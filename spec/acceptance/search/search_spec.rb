require 'acceptance_helper'

feature 'user can search questions, answers, comments' do
  let!(:user){ create(:user, email: 'text@user.rb') }
  let!(:question) { create :question }
  let!(:answer) { create :answer }
  let!(:comment) { create :comment, commentable: question }

  background do
    index
    visit root_path
  end

  context 'with non result search' do
    scenario 'user search with empty query', js: true do
      click_button 'Find'

      expect(page).to have_content('Not found')
    end

    scenario 'user search with non include query', js: true do
      fill_in 'query', with: 'any word'
      click_on 'Find'

      expect(page).to have_content('Not found')
    end
  end

  context 'with result search' do
    scenario 'user all search', js: true do
      fill_in 'query', with: 'Body'
      select 'All', from: 'resource'
      click_on 'Find'

      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
    end

    scenario 'user questions search', js: true do
      fill_in 'query', with: 'Body'
      select 'Questions', from: 'resource'
      click_on 'Find'

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end

    scenario 'user search answer', js: true do
      fill_in 'query', with: 'Body'
      select 'Answers', from: 'resource'
      click_on 'Find'

      expect(page).to have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content answer.body
      expect(page).to have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end

    scenario 'user search comment', js: true do
      fill_in 'query', with: 'Body'
      select 'Comments', from: 'resource'
      click_on 'Find'

      expect(page).to have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to_not have_content user.email
    end

    scenario 'user search users', js: true do
      fill_in 'query', with: 'text'
      select 'Users', from: 'resource'
      click_on 'Find'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to have_content user.email
    end
  end
end
