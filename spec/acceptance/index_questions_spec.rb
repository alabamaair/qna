require 'rails_helper'

feature 'Index questions' do

  let!(:questions) { create_list :question, 2 }

  scenario 'User can to see list of questions' do
    visit '/questions'

    expect(page).to have_content /Title/, minimum: 2
    expect(page).to have_content /Body/, minimum: 2
  end
end