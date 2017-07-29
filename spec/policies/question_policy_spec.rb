require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { QuestionPolicy.new(user, question) }

  let(:question) { create(:question, user: user) }

  context "for a visitor" do
    let(:user) { nil }
    let(:question) { create(:question) }

    it { should     permit(:show)    }
    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
    it { should_not permit(:mark_best_answer) }
  end

  context "for a user" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
    it { should permit(:mark_best_answer) }
  end

  context "for a user non-author" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
  end
end
