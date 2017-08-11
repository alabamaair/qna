require 'rails_helper'

RSpec.describe SubscriptionPolicy do
  subject { SubscriptionPolicy.new(user, subscription) }

  let(:subscription) { create(:subscription, user: user) }

  context "for a visitor" do
    let(:user) { nil }
    let(:subscription) { create(:subscription) }

    it { should_not permit(:create)  }
    it { should_not permit(:destroy) }
  end

  context "for an user" do
    let(:user) { create(:user) }
    let(:subscription) { create(:subscription, user: user) }

    it { should permit(:create)  }
    it { should permit(:destroy) }
  end
end
