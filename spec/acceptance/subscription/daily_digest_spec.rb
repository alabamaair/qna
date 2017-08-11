require 'acceptance_helper'

feature 'Daily digest' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:old_question) { create(:question, title: 'Other', created_at: 1.week.ago) }

  scenario 'user receives daily digest on email' do
    DailyDigestJob.perform_now
    open_email(user.email)
    expect(current_email).to have_content question.title
    expect(current_email).to have_content question.title
  end

  scenario 'user receives only questions created yesterday' do
    DailyDigestJob.perform_now
    open_email(user.email)

    expect(current_email).to have_content question.title
    expect(current_email).to have_content question.title

    expect(current_email).not_to have_content old_question.title
    expect(current_email).not_to have_content old_question.title
  end
end