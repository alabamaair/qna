require 'rails_helper'

feature 'Delete answer' do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:user2) { create(:user) }

  scenario 'Authenticated user-author try delete the answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Destroy answer'

    expect(page).to have_content 'Answer destroy successfully.'
  end

  scenario 'Authenticated user non-author try delete the answer' do
    sign_in(user2)

    visit question_path(question)
    click_on 'Destroy answer'

    expect(page).to have_content 'You not an author.'
  end

  scenario 'Non-authenticated user try to destroy answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Destroy'
  end
end