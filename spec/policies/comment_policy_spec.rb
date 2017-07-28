require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { CommentPolicy.new(user, comment) }

  let(:comment) { create(:comment, user: user) }

  context "for a visitor" do
    let(:user) { nil }
    let(:comment) { create(:comment) }

    it { should     permit(:show)    }
    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:destroy) }
  end

  context "for a user-author" do
    let(:user) { create(:user) }
    let(:comment) { create(:comment, user: user) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:destroy) }
  end

  context "for a user non-author" do
    let(:user) { create(:user) }
    let(:comment) { create(:comment) }

    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
  end
end
