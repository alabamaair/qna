# frozen_string_literal: true
class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_one :best_answer, -> { where(best: true) }, class_name: 'Answer'
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].nil? }

  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, :body, :user_id, presence: true
end
