# frozen_string_literal: true
class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].nil? }

  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  after_create_commit { AnswersNotifierJob.perform_later(self) }

  default_scope { order(created_at: :asc) }

  def mark_best
    ActiveRecord::Base.transaction do
      question.answers.where('best = ?', true).update_all(best: false) # no callbacks!
      update!(best: true)
    end
  end
end
