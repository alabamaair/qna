require 'rails_helper'

RSpec.describe ProfilesPolicy do
  subject { ProfilesPolicy.new(user, :profiles) }

  context "for a visitor" do
    let(:user) { nil }

    it { should_not permit(:me)   }
    it { should_not permit(:index) }
  end

  context "for a user" do
    let(:user) { create(:user) }

    it { should permit(:me)    }
    it { should permit(:index)  }
  end
end
