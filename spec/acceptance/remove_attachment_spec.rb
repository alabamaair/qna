require 'acceptance_helper'

feature 'Delete attachment' do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:attachment) { create(:attachment, attachable: question) }
  let(:attachment2) { create(:attachment, attachable: answer) }
  let(:user2) { create(:user) }

  scenario 'Authenticated user-author try delete attachment from question', js: true do
    attachment
    sign_in(user)
    visit question_path(question)

    within '.question-container' do
      click_on 'remove attachment'

      expect(page).not_to have_link attachment.file.filename, href: attachment.file.url
    end
  end

  scenario 'Authenticated user-author delete attachment from answer', js: true do
    attachment2
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'remove attachment'

      expect(page).not_to have_link attachment2.file.filename, href: attachment2.file.url
    end
  end

  scenario 'Authenticated user non-author try delete attachment', js: true do
    sign_in(user2)
    visit question_path(question)

    within '.question-container' do
      expect(page).not_to have_content 'remove attachment'
    end
  end

  scenario 'Non-authenticated user try to destroy attachment', js: true do
    visit question_path(question)

    expect(page).not_to have_content 'remove attachment'
  end
end