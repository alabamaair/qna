# frozen_string_literal: true
class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_one :best_answer, -> { where(best: true) }, class_name: 'Answer'
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].nil? }

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  after_create :subscribe_author

  validates :title, :body, :user_id, presence: true

  scope :in_digest, -> { where(created_at: Time.zone.now - 24.hours..Time.zone.now) }

  def subscribe?(user)
    subscriptions.where(user_id: user.id).exists?
  end

  def subscription(user)
    subscriptions.find_by(user_id: user.id)
  end

  private

  def subscribe_author
    subscriptions.create(user_id: user.id)
  end
end
