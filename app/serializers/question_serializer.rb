class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :short_title

  has_many :attachments
  has_many :comments

  def short_title
    object.title.truncate(10)
  end
end
