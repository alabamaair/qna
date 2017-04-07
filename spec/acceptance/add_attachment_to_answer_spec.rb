require 'acceptance_helper'

feature 'Create attachment to answer', %q{
  In order to illustrate answer
  As an authenticated user
  I want to be able add file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user create attachment for answer', js: true do
    fill_in 'Body', with: 'Body answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end
  end

end