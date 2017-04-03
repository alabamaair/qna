require 'acceptance_helper'

feature 'Edit question', %q{
  In order to update question
  As an authenticated user and author
  I want to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link Edit question' do
      expect(page).to have_content 'Edit'
    end

    scenario 'edit his question', js: true do
      click_on 'Edit'
      within '.edit-question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Update Question'

        expect(page).not_to have_selector 'textarea'
      end
      expect(page).not_to have_content question.body
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'edited body'
    end

    scenario 'Authenticated user try update question with invalid attributes', js: true do
      click_on 'Edit'
      within '.edit-question' do
        fill_in 'Body', with: ''
        click_on 'Update Question'
      end
      
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  scenario 'Non-authenticated user try to edit question' do
    visit question_path(question)

    expect(page).not_to have_content 'Edit'
  end

  scenario 'Authenticated non-author try edit question' do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).not_to have_content 'Edit'
  end
end