class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true, touch: true
  belongs_to :user

  validates :value, inclusion: { in: [1, -1] }
end
