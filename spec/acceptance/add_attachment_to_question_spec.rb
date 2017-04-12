require 'acceptance_helper'

feature 'Create attachment for question', %q{
  In order to illustrate question
  As an authenticated user
  I want to be able add file
} do

  let(:user) { create(:user) }

  background do
    sign_in(user)

    visit '/questions'
    click_on 'Ask question'

    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
  end

  scenario 'Authenticated user create attachment for question', js: true do

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper', href: '/uploads/attachment/file/1/spec_helper.rb'
  end


  scenario 'Authenticated user create multiple attachments for question', js: true do
    click_on 'add attachment'
    page.all(:css, 'input[type="file"]').each do |el|
      el.set "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Create'

    within '.question-container' do
      expect(page).to have_link 'spec_helper', count: 2
    end
  end

end