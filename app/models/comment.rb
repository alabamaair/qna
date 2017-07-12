class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
  validates :commentable, presence: true
  validates :user, presence: true
end
