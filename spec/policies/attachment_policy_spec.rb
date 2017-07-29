require 'rails_helper'

RSpec.describe AttachmentPolicy do
  subject { AttachmentPolicy.new(user, attachment) }

  let(:attachment) { create(:attachment, user: user) }

  context "for a visitor" do
    let(:user) { nil }
    let(:attachable) { create(:question) }
    let(:attachment) { create(:attachment, attachable: attachable) }

    it { should     permit(:show)    }
    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:destroy) }
  end

  context "for a user-author" do
    let(:user) { create(:user) }
    let(:attachable) { create(:question, user: user) }
    let(:attachment) { create(:attachment, attachable: attachable) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:destroy) }
  end

  context "for a user non-author" do
    let(:user) { create(:user) }
    let(:attachable) { create(:question) }
    let(:attachment) { create(:attachment, attachable: attachable) }

    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
  end
end
