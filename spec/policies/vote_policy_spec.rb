require 'rails_helper'

RSpec.describe VotePolicy do
  subject { VotePolicy.new(user, vote) }

  let(:votable) { create(:question) }

  context "for user an author" do
    let(:user) { create(:user) }
    let(:votable) { create(:question, user: user) }
    let(:vote) { create(:vote, votable: votable, user: user, value: 1) }


    it { should     permit(:show)      }
    it { should_not permit(:vote_up)   }
    it { should_not permit(:vote_down) }
    it { should_not permit(:unvote)    }
  end

  context "for an another user" do
    let(:user) { create(:user) }
    let(:vote) { create(:vote, votable: votable, user: user, value: 1) }

    it { should permit(:show)      }
    it { should permit(:vote_up)   }
    it { should permit(:vote_down) }
    it { should permit(:unvote)    }
  end
end
