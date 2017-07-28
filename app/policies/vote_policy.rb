class VotePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def vote_up?
    user != record.votable.user
  end

  def vote_down?
    user != record.votable.user
  end

  def unvote?
    user == record.user && user != record.votable.user
  end
end
