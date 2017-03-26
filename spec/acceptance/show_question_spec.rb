require 'acceptance_helper'

feature 'View the question with answers' do

  let!(:question) { create :question }
  let!(:answer) { create_list :answer, 2, question: question }

  scenario 'Any user get the question with answers' do

    visit question_path(question)

    expect(page).to have_content 'Body'
    expect(page).to have_content /Answer body/, minimum: 2
  end
end