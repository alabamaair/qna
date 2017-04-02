# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :best_answer, -> { where(best: true) }, class_name: Answer
  belongs_to :user

  validates :title, :body, presence: true

  def unchecked_answers
    answers.where('best = ?', true).update_all(best: false)
  end
end
