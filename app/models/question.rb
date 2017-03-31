# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: Answer, foreign_key: :best_answer_id, optional: true
  belongs_to :user

  validates :title, :body, presence: true

  def unchecked_answers
    answers.where('best = ?', true).update_all(best: false)
  end
end
