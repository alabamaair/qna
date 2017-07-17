module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def label_vote
    "#{self.class.name.underscore}_#{id}"
  end
end
