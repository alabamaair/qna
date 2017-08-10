require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:question) { create :question }
  let!(:users) { create_list :user, 3 }

  it 'sends daily digest to each user' do
    users.each { |u| expect(DailyMailer).to receive(:digest).with(u).and_call_original }
    DailyDigestJob.perform_now
  end
end
