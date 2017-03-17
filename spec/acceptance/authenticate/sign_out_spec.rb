require 'rails_helper'

feature 'Sign out' do

  let(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)

    visit root_path
    click_on 'Sign Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end