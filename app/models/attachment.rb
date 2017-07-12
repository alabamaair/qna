class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true

  validates :file, presence: true

  mount_uploader :file, FileUploader

  def with_meta
    Hash['filename', file.filename, 'url', file.url]
  end
end
